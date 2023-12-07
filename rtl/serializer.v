module serializer #(
    parameter  WIDTH=8
) (
    input  wire clk,enable,rst,data_valid,
    input  wire [WIDTH-1:0] i_data,
    output wire o_data
);

reg [WIDTH-1:0] shift_reg;

 always @(posedge clk or negedge rst) begin
     if (!rst)
        shift_reg <= 'b0;        
     else if(data_valid)
        shift_reg <= i_data;
     else if(enable)
        shift_reg <= {shift_reg[WIDTH-1:0], 1'b0};
 end
    
assign o_data = shift_reg[WIDTH-1];

endmodule