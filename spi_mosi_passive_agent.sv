class spi_mosi_passive_agent extends uvm_agent;
`uvm_component_utils(spi_mosi_passive_agent)

spi_mosi_monitor m0;
uvm_analysis_port#(spi_sequence_item) analysis_port;
virtual spi_intf spi_vif;

function new (string name="spi_mosi_passive_agent", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("mosi passive agent Build Phase"), UVM_HIGH)

    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(),$sformatf("Couldnt get vif in test"));
    uvm_config_db #(virtual spi_intf)::set(this, "m0", "spi_vif", spi_vif);

    m0 = spi_mosi_monitor::type_id::create("m0", this);
    analysis_port = new("analysis_port", this);

endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), $sformatf("connect phase"), UVM_HIGH)
    m0.analysis_port.connect(analysis_port);

endfunction
endclass