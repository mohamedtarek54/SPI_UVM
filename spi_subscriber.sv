class spi_subscriber extends uvm_subscriber#(spi_sequence_item);
    `uvm_component_utils(spi_subscriber)
localparam WIDTH = 8;

bit                                 i_Rst_L,i_TX_DV,i_SPI_MISO;
bit         [WIDTH-1:0]             i_TX_Byte;
logic       [WIDTH-1:0]             o_RX_Byte;
logic                               o_SPI_MOSI,o_TX_Ready,o_SPI_Clk;

covergroup cg_spi;
    coverpoint i_TX_Byte;
    coverpoint o_RX_Byte;
endgroup

function new(string name="spi_subscriber", uvm_component parent=null);
    super.new(name, parent);
    cg_spi = new;
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("build phase"), UVM_DEBUG)
endfunction

function void write(T t);
    // if($isunknown(t.byte_holder))
    //     t.byte_holder = 8'b0;
    // if($isunknown(t.i_TX_Byte))
    //     t.i_TX_Byte = 8'b0;
    // if($isunknown(t.o_RX_Byte))
    //     t.o_RX_Byte = 8'b0;
    
    i_TX_DV = t.i_TX_DV;
    i_TX_Byte = t.i_TX_Byte;
    o_RX_Byte = t.o_RX_Byte;
    o_TX_Ready = t.o_TX_Ready;

    `uvm_info(get_type_name(), $sformatf("holder: %8b, tx: %8b, rx: %8b", t.byte_holder, t.i_TX_Byte, t.o_RX_Byte), UVM_LOW)

    cg_spi.sample();
endfunction

endclass