class spi_tx_monitor extends uvm_monitor;
`uvm_component_utils(spi_tx_monitor)

spi_sequence_item s0;
uvm_analysis_port#(spi_sequence_item) analysis_port;
virtual spi_intf spi_vif;

function new (string name="spi_tx_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("tx monitor Build Phase"), UVM_HIGH)

    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(),$sformatf("Couldnt get vif in test"));
    
    s0 = spi_sequence_item::type_id::create("s0");
    analysis_port = new("analysis_port", this);

endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), $sformatf("run Phase"), UVM_HIGH)
    while(1) begin
        @(posedge spi_vif.i_TX_DV)
        s0.i_TX_Byte = spi_vif.i_TX_Byte;
        `uvm_info(get_type_name(), $sformatf("sampled input byte: %8b", s0.i_TX_Byte), UVM_DEBUG)
        analysis_port.write(s0);
    end
endtask

endclass