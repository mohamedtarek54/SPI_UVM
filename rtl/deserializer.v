module deserializer #(
    parameter WIDTH=8
) (
    input  wire                          clk,rst,enable,i_bit,
    output wire [WIDTH-1:0]              o_data 
);

reg [WIDTH-1:0] shift_reg;

always @(posedge clk, negedge rst) begin
    if(!rst)
        shift_reg <= 'b0;
    else if(enable)
        shift_reg <= {shift_reg[WIDTH-2:0], i_bit};
end

assign o_data = shift_reg;
endmodule