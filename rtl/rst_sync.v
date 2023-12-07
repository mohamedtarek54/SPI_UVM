module rst_sync (
    input wire clk,
    input wire async_rst,

    output reg sync_rst
);
    
reg reg_a;

always @(posedge clk, negedge async_rst) begin
    if(!async_rst) begin
        reg_a       <= 1'b0;
        sync_rst    <= 1'b0;
    end else begin
        reg_a       <= 1'b1;
        sync_rst    <= reg_a;
    end
end

endmodule