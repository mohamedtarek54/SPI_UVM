class spi_tx_sequence extends uvm_sequence;
`uvm_object_utils(spi_tx_sequence)

spi_sequence_item s0;

function new (string name="spi_tx_sequence");
    super.new(name);
endfunction

task pre_body();
    `uvm_info(get_type_name(), $sformatf("pre_body"), UVM_HIGH)
    s0 = spi_sequence_item::type_id::create("s0");
endtask

task body();
    const int BYTES_NUM = 100;
    for(int i=0; i<BYTES_NUM; i++) begin
        start_item(s0);
        assert(s0.randomize())
        `uvm_info(get_type_name(), $sformatf("randomized tx byte #%0d: %0b", i, s0.i_TX_Byte), UVM_DEBUG)
        finish_item(s0);
    end
endtask
endclass