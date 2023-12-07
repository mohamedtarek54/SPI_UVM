class spi_tx_driver extends uvm_driver #(spi_sequence_item);
`uvm_component_utils(spi_tx_driver)

virtual spi_intf spi_vif;
spi_sequence_item s0;

function new (string name="spi_tx_driver", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("tx driver Build Phase"), UVM_HIGH)

    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(), "couldnt get vif");
    
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Run Phase"), UVM_HIGH)
    while(1) begin
        seq_item_port.get_next_item(s0);
        `uvm_info(get_type_name(), $sformatf("received tx byte: %8b", s0.i_TX_Byte), UVM_DEBUG)
        drive_item(s0);
        seq_item_port.item_done();
    end
endtask

task drive_item(spi_sequence_item item);
    @(posedge spi_vif.clk)
    spi_vif.i_TX_DV <= 1'b1;
    spi_vif.i_TX_Byte <= item.i_TX_Byte; 
    @(posedge spi_vif.clk)
    spi_vif.i_TX_DV <= 1'b0;
    // spi_vif.i_TX_Byte <= 'b0;

    @(posedge spi_vif.o_TX_Ready);
endtask
endclass