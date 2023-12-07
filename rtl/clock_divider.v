module clock_divider #(parameter DIVIDE=8)(
    input wire i_rst_l,
    input wire i_clk,
    input wire i_cpol,
    input wire i_tx_valid,

    output wire o_clk,
    output wire o_tx_rdy,
    output wire o_leading_edge,
    output wire o_trailing_edge
);

localparam N = $clog2(DIVIDE);
wire clock_divided;
reg oclk_en;
reg [N-1:0] counter;
always @(posedge i_clk or negedge i_rst_l) begin
    if(!i_rst_l)
        counter <= 'b0;
    else if(i_tx_valid && i_cpol==1'b1)
        counter <= 'b0;
    else if(i_tx_valid && i_cpol==1'b0)
        counter <= 'b100;
    else if(oclk_en)
        counter <= counter + 'b1;
end
 


// output clock logic
reg [3:0] valid_delayed;
always @(posedge i_clk or negedge i_rst_l) begin
    if(!i_rst_l)
        valid_delayed <= 3'b0;
    else
        valid_delayed <= {i_tx_valid, valid_delayed[3:1]};
end

reg [3:0] edge_counter;

wire clken_valid = oclk_en | valid_delayed[0];
wire finish = (edge_counter==4'd8)?1'b0:1'b1;

always @(posedge i_clk or negedge i_rst_l) begin
    if(!i_rst_l)
        oclk_en <= 1'b0;
    else
        oclk_en <= clken_valid & finish;
end
/////////////////////////////
reg [2:0] leading_counter;
always @(posedge i_clk or negedge i_rst_l) begin
    if(!i_rst_l)
        leading_counter <= 'b0;
    else if(i_tx_valid)
        leading_counter <= 'b0;
    else if(clken_valid)
        leading_counter <= leading_counter + 'b1;
end
//

always @(posedge i_clk or negedge i_rst_l) begin
    if(!i_rst_l)
        edge_counter <= 4'b0;
    else if(i_tx_valid)
        edge_counter <= 'b0;
    else if(o_trailing_edge)
        edge_counter <= edge_counter + 4'b1;
end

//
assign clock_divided = counter[N-1];
assign o_tx_rdy      = (edge_counter == 4'd7 && o_trailing_edge)? 1'b1:1'b0;
assign o_clk = (oclk_en)?clock_divided:i_cpol;
assign o_leading_edge = (leading_counter == 3'b0 && clken_valid)?1'b1:1'b0;
assign o_trailing_edge= (counter == 3'b011 & i_cpol || counter == 3'b111 & !i_cpol)?1'b1:1'b0;
endmodule