class spi_test extends uvm_test;
`uvm_component_utils(spi_test)

virtual spi_intf spi_vif;
spi_env env0;
spi_tx_sequence tx_seq0;
spi_miso_sequence miso_seq0;

function new (string name="spi_test", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("test Build Phase"), UVM_HIGH)

    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(),$sformatf("Couldnt get vif in test"));
    uvm_config_db #(virtual spi_intf)::set(this, "env0", "spi_vif", spi_vif);
    
    env0 = spi_env::type_id::create("env0", this);
    tx_seq0 = spi_tx_sequence::type_id::create("tx_seq0");
    miso_seq0 = spi_miso_sequence::type_id::create("miso_seq0");
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Connect Phase"), UVM_HIGH)
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Run Phase"), UVM_HIGH)

    phase.raise_objection(this);
    spi_vif.reset();
    fork
        tx_seq0.start(env0.a1.seqr0);
        miso_seq0.start(env0.a3.seqr0);
    join
    #10
    phase.drop_objection(this);
endtask
endclass