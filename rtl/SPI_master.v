module SPI_Master #(
    parameter WIDTH=8
) (
    input   wire                    i_Clk,i_Rst_L,i_TX_DV,i_SPI_MISO,
    input   wire  [WIDTH-1:0]       i_TX_Byte,
    output  wire  [WIDTH-1:0]       o_RX_Byte,
    output  wire                    o_SPI_MOSI,o_TX_Ready,o_SPI_Clk 

);

wire o_trailing_edge,o_leading_edge;
wire cpol = 1'b1;

rst_sync u_rst_sync (
.clk(i_Clk),
.async_rst(i_Rst_L),

.sync_rst(sync_rst)
);

clock_divider u_clock_divider (
.i_rst_l(sync_rst),
.i_clk(i_Clk),
.i_cpol(cpol),
.i_tx_valid(i_TX_DV),

.o_clk(o_SPI_Clk),
.o_tx_rdy(o_TX_Ready),
.o_leading_edge(o_leading_edge),
.o_trailing_edge(o_trailing_edge)
);

serializer #(.WIDTH(WIDTH)) u_serializer(
    .clk(i_Clk),
    .enable(o_leading_edge),
    .rst(sync_rst),
    .data_valid(i_TX_DV),
    .i_data(i_TX_Byte),

    .o_data(o_SPI_MOSI)
    );

deserializer #(.WIDTH(WIDTH)) u_deserializer (
    .clk(i_Clk),
    .enable(o_trailing_edge),
    .rst(sync_rst),
    .i_bit(i_SPI_MISO),
    
    .o_data(o_RX_Byte)
);
    
endmodule