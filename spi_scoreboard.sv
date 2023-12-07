class spi_scoreboard extends uvm_scoreboard;
`uvm_component_utils(spi_scoreboard)
`uvm_analysis_imp_decl(_mosi_mon2scb)
`uvm_analysis_imp_decl(_tx_mon2scb)
`uvm_analysis_imp_decl(_rx_mon2scb)
`uvm_analysis_imp_decl(_miso_mon2scb)

uvm_analysis_imp_mosi_mon2scb#(spi_sequence_item, spi_scoreboard) mosi_analysis_imp;
uvm_analysis_imp_tx_mon2scb#(spi_sequence_item, spi_scoreboard) tx_analysis_imp;
uvm_analysis_imp_rx_mon2scb#(spi_sequence_item, spi_scoreboard) rx_analysis_imp;
uvm_analysis_imp_miso_mon2scb#(spi_sequence_item, spi_scoreboard) miso_analysis_imp;

mailbox #(spi_sequence_item) tx2mosi_mb;
mailbox #(spi_sequence_item) miso2rx_mb;

spi_sequence_item mb_tx_seq_item;
spi_sequence_item mb_rx_seq_item;

function new (string name="spi_scoreboard", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("scoreboard Build Phase"), UVM_HIGH)

    mb_tx_seq_item = spi_sequence_item::type_id::create("mb_tx_seq_item");
    mb_rx_seq_item = spi_sequence_item::type_id::create("mb_rx_seq_item");

    mosi_analysis_imp = new("mosi_analysis_imp", this);
    tx_analysis_imp = new("tx_analysis_imp", this);
    rx_analysis_imp = new("rx_analysis_imp", this);
    miso_analysis_imp = new("miso_analysis_imp", this);

    tx2mosi_mb = new(1);
    miso2rx_mb = new(1);
endfunction

function void write_mosi_mon2scb (spi_sequence_item item);
    `uvm_info(get_type_name(), $sformatf("write mosi function"), UVM_HIGH)
    
    assert(tx2mosi_mb.try_get(mb_tx_seq_item)) begin
    if(item.byte_holder == mb_tx_seq_item.i_TX_Byte)
        `uvm_info(get_type_name(), $sformatf("PASS received mosi byte from monitor: %8b", item.byte_holder), UVM_LOW)
    else
        `uvm_info(get_type_name(), $sformatf("FAIL received mosi byte: %8b, actual: %8b", item.byte_holder, mb_tx_seq_item.i_TX_Byte), UVM_LOW)
    end else begin
        `uvm_error(get_type_name(), $sformatf("FAIL to get from mailbox in write_mosi_mon2scb"))
    end
endfunction

function void write_tx_mon2scb (spi_sequence_item item);
    `uvm_info(get_type_name(), $sformatf("write tx function"), UVM_HIGH)
    `uvm_info(get_type_name(), $sformatf("received tx byte from monitor: %8b", item.i_TX_Byte), UVM_DEBUG)
    assert(tx2mosi_mb.try_put(item));
endfunction

function void write_rx_mon2scb (spi_sequence_item item);
    `uvm_info(get_type_name(), $sformatf("write rx function"), UVM_HIGH)

    assert(miso2rx_mb.try_get(mb_rx_seq_item)) begin
    if(item.o_RX_Byte == mb_rx_seq_item.byte_holder)
        `uvm_info(get_type_name(), $sformatf("PASS received miso byte from monitor: %8b", item.o_RX_Byte), UVM_LOW)
    else
        `uvm_info(get_type_name(), $sformatf("FAIL received miso byte: %8b, actual: %8b", item.o_RX_Byte, mb_tx_seq_item.byte_holder), UVM_LOW)
    end else begin
        `uvm_error(get_type_name(), $sformatf("FAIL to get from mailbox in write_rx_mon2scb"))
    end

endfunction

function void write_miso_mon2scb (spi_sequence_item item);
    `uvm_info(get_type_name(), $sformatf("write miso function"), UVM_HIGH)
    `uvm_info(get_type_name(), $sformatf("received miso byte from monitor: %8b", item.byte_holder), UVM_DEBUG)
    assert(miso2rx_mb.try_put(item));
endfunction
endclass