module spi_top;
    import uvm_pkg::*;
    import spi_pkg::*;
`include "uvm_macros.svh"

localparam  PERIOD = 10,
            DATA_WIDTH = 8;

// Clock Generation
logic clk;
initial clk = 1'b0;
always #(PERIOD/2) clk = ~clk;
//-----------------------------

// instantiate interafce and DUT
spi_intf #(.WIDTH(DATA_WIDTH)) intf (
    .clk(clk)
);

SPI_Master #(.WIDTH(DATA_WIDTH)) u_SPI_Master (
    .i_Clk(clk), .i_Rst_L(intf.i_Rst_L), .i_TX_DV(intf.i_TX_DV), .i_SPI_MISO(intf.i_SPI_MISO),
    .i_TX_Byte(intf.i_TX_Byte),
    .o_RX_Byte(intf.o_RX_Byte),
    .o_SPI_MOSI(intf.o_SPI_MOSI), .o_TX_Ready(intf.o_TX_Ready), .o_SPI_Clk(intf.o_SPI_Clk) 
);
//-----------------------------


initial begin
    uvm_config_db #(virtual spi_intf)::set(null, "uvm_test_top", "spi_vif", intf);
    run_test("spi_test");
end
endmodule