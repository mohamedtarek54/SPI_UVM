import uvm_pkg::*;
`include "uvm_macros.svh"

interface spi_intf #(parameter WIDTH=8) (input logic clk);
logic                   i_Rst_L,i_TX_DV,i_SPI_MISO;
logic [WIDTH-1:0]       i_TX_Byte;
logic [WIDTH-1:0]       o_RX_Byte;
logic                   o_SPI_MOSI,o_TX_Ready,o_SPI_Clk; 

task reset();
    `uvm_info("spi_intf", $sformatf("reset task started"), UVM_DEBUG)
    i_Rst_L = 1'b0;
    i_TX_DV = 1'b0;
    i_TX_Byte = 'b0;
    i_SPI_MISO = 'b0;
    repeat(5) @(negedge clk)
    i_Rst_L = 1'b1;
    `uvm_info("spi_intf", $sformatf("reset task finished"), UVM_DEBUG)
endtask
endinterface