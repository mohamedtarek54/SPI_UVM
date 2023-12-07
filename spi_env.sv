class spi_env extends uvm_env;
`uvm_component_utils(spi_env)



spi_mosi_passive_agent a0;
spi_tx_active_agent a1;
spi_rx_passive_agent a2;
spi_miso_active_agent a3;

spi_subscriber sub0;
spi_scoreboard s0;
virtual spi_intf spi_vif;

function new (string name="spi_env", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Build Phase"), UVM_HIGH)

    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(),$sformatf("Couldnt get vif in test"));


    uvm_config_db #(virtual spi_intf)::set(this, "a0", "spi_vif", spi_vif);
    uvm_config_db #(virtual spi_intf)::set(this, "a1", "spi_vif", spi_vif);
    uvm_config_db #(virtual spi_intf)::set(this, "a2", "spi_vif", spi_vif);
    uvm_config_db #(virtual spi_intf)::set(this, "a3", "spi_vif", spi_vif);

    a0 = spi_mosi_passive_agent::type_id::create("a0", this);
    a1 = spi_tx_active_agent::type_id::create("a1", this);
    a2 = spi_rx_passive_agent::type_id::create("a2", this);
    a3 = spi_miso_active_agent::type_id::create("a3", this);
    s0 = spi_scoreboard::type_id::create("s0", this);
    sub0 = spi_subscriber::type_id::create("sub0", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Connect Phase"), UVM_HIGH)
    // connect agents with scoreboard
    a0.analysis_port.connect(s0.mosi_analysis_imp);
    a1.analysis_port.connect(s0.tx_analysis_imp);
    a2.analysis_port.connect(s0.rx_analysis_imp);
    a3.analysis_port.connect(s0.miso_analysis_imp);

    // connect agents with subscriber
    a0.analysis_port.connect(sub0.analysis_export);
    a1.analysis_port.connect(sub0.analysis_export);
    a2.analysis_port.connect(sub0.analysis_export);
    a3.analysis_port.connect(sub0.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Run Phase"), UVM_HIGH)
    
endtask
endclass