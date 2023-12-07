class spi_sequence_item extends uvm_sequence_item;
`uvm_object_utils(spi_sequence_item)
localparam WIDTH = 8;

function new (string name="spi_sequence_item");
    super.new(name);
endfunction
rand logic [WIDTH-1:0]   byte_holder;

rand bit                            i_Rst_L,i_TX_DV,i_SPI_MISO;
rand bit    [WIDTH-1:0]             i_TX_Byte;
logic       [WIDTH-1:0]             o_RX_Byte;
logic                               o_SPI_MOSI,o_TX_Ready,o_SPI_Clk;

// add constraints

endclass : spi_sequence_item