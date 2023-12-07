class spi_miso_driver extends uvm_driver #(spi_sequence_item);
`uvm_component_utils(spi_miso_driver)

virtual spi_intf spi_vif;
spi_sequence_item s0;

function new (string name="spi_miso_driver", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual spi_intf)::get(this, "", "spi_vif", spi_vif))
        `uvm_fatal(get_type_name(), "couldnt get vif");
    `uvm_info(get_type_name(), $sformatf("miso driver Build Phase"), UVM_HIGH)
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Run Phase"), UVM_HIGH)
    forever begin
        seq_item_port.get_next_item(s0);
        drive(s0);
        seq_item_port.item_done();
    end
endtask

task drive(spi_sequence_item item);
@(posedge spi_vif.i_TX_DV)
repeat(8) begin
    repeat(8) @(posedge spi_vif.clk);
    spi_vif.i_SPI_MISO = item.byte_holder[7];
    item.byte_holder = item.byte_holder<<1;
end
endtask

endclass