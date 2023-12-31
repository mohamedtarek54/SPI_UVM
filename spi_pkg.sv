package spi_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "spi_sequence_item.sv"
`include "spi_tx_sequence.sv"
`include "spi_miso_sequence.sv"

`include "spi_miso_driver.sv"
`include "spi_tx_driver.sv"

`include "spi_mosi_monitor.sv"
`include "spi_tx_monitor.sv"
`include "spi_rx_monitor.sv"
`include "spi_miso_monitor.sv"

`include "spi_tx_active_agent.sv"
`include "spi_rx_passive_agent.sv"
`include "spi_mosi_passive_agent.sv"
`include "spi_miso_active_agent.sv"

`include "spi_scoreboard.sv"

`include "spi_subscriber.sv"

`include "spi_env.sv"

`include "spi_test.sv"

endpackage
