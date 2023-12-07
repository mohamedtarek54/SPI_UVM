class spi_tx_active_agent extends uvm_agent;
`uvm_component_utils(spi_tx_active_agent)

spi_tx_monitor m0;
spi_tx_driver d0;
uvm_analysis_port#(spi_sequence_item) analysis_port;
uvm_sequencer #(spi_sequence_item) seqr0;
virtual spi_intf spi_vif;

function new (string name="spi_tx_active_agent", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("tx active agent Build Phase"), UVM_HIGH)

    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(),$sformatf("Couldnt get vif in test"));
    uvm_config_db #(virtual spi_intf)::set(this, "d0", "spi_vif", spi_vif);
    uvm_config_db #(virtual spi_intf)::set(this, "m0", "spi_vif", spi_vif);

    m0 = spi_tx_monitor::type_id::create("m0", this);
    d0 = spi_tx_driver::type_id::create("d0", this);
    analysis_port = new("analysis_port", this);
    seqr0 = new("seqr0", this);

endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), $sformatf("connect phase"), UVM_HIGH)
    m0.analysis_port.connect(analysis_port);
    // connect sequencer with driver
    d0.seq_item_port.connect(seqr0.seq_item_export);
endfunction

endclass