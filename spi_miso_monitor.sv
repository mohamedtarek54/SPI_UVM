class spi_miso_monitor extends uvm_monitor;
`uvm_component_utils(spi_miso_monitor)

spi_sequence_item seq0;
uvm_analysis_port#(spi_sequence_item) analysis_port;
virtual spi_intf spi_vif;
logic [7:0] miso_byte;

function new (string name="spi_miso_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Build Phase"), UVM_HIGH)
    
    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(),$sformatf("Couldnt get vif"));
    
    analysis_port = new("analysis_port", this);
    seq0 = spi_sequence_item::type_id::create("seq0");
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Run Phase"), UVM_HIGH)

    while(1) begin
    @(posedge spi_vif.i_TX_DV)
    repeat(8) begin
        repeat(8) @(posedge spi_vif.clk);
        `uvm_info(get_type_name(), $sformatf("miso sent bit: %0b", spi_vif.i_SPI_MISO), UVM_DEBUG)
        miso_byte = {miso_byte[6:0], spi_vif.i_SPI_MISO};
    end
    `uvm_info(get_type_name(), $sformatf("miso sent byte: %8b", miso_byte), UVM_DEBUG)
    seq0.byte_holder = miso_byte;
    analysis_port.write(seq0);
    end
endtask

endclass