class spi_mosi_monitor extends uvm_monitor;
`uvm_component_utils(spi_mosi_monitor)

spi_sequence_item seq0;
uvm_analysis_port#(spi_sequence_item) analysis_port;
virtual spi_intf spi_vif;
logic [7:0] mosi_byte;

function new (string name="spi_mosi_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Build Phase"), UVM_HIGH)

    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(),$sformatf("Couldnt get vif"));
    
    seq0 = spi_sequence_item::type_id::create("seq0");
    analysis_port = new("analysis_port", this);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Run Phase"), UVM_HIGH)

    while(1) begin
        // `uvm_info(get_type_name(), $sformatf("waiting for tx valid"), UVM_LOW)
        @(posedge spi_vif.i_TX_DV)
        // `uvm_info(get_type_name(), $sformatf("tx valid came"), UVM_LOW)
        repeat(4) @(posedge spi_vif.clk);
        // `uvm_info(get_type_name(), $sformatf("now at first bit"), UVM_LOW)
        repeat(7) begin
            // append received bit into result
            mosi_byte = {mosi_byte[6:0], spi_vif.o_SPI_MOSI};
            // `uvm_info(get_type_name(), $sformatf("sampled bit: %b", spi_vif.o_SPI_MOSI), UVM_LOW)
            repeat(8) @(posedge spi_vif.clk);
            // `uvm_info(get_type_name(), $sformatf("now on next bit"), UVM_LOW)
        end
        mosi_byte = {mosi_byte[6:0], spi_vif.o_SPI_MOSI};
        // `uvm_info(get_type_name(), $sformatf("*********byte received***********"), UVM_LOW)
        // `uvm_info(get_type_name(), $sformatf("mosi byte: %8b", mosi_byte), UVM_LOW)
        seq0.byte_holder = mosi_byte;
        analysis_port.write(seq0);
    end
endtask
endclass