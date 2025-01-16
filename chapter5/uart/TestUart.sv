`timescale 1ns / 100ps

`include "../../chapter4/scfifo/ScFifo2.sv"
`include "../../SimSrcGen.sv"
`include "./UartRx.sv"
`include "./UartTx.sv"

module TestUart;
  import SimSrcGen::*;
  logic clk, rst;
  initial GenClk(clk, 8, 10);
  initial GenRst(clk, rst, 1, 1);
  logic rst_n;
  assign rst_n = ~rst;

  logic [7:0] tx_fifo_din, tx_fifo_dout;
  logic [8:0] rx_fifo_din, rx_fifo_dout;
  logic tx_fifo_write = '0, tx_fifo_read, tx_fifo_empty;
  logic rx_fifo_write, rx_fifo_read = '0;
  logic [3:0] rx_fifo_dc;
  ScFifo2 #(
      .DW(8),
      .AW(4)
  ) theTxFifo (
    .clk     (clk),
    .rst_n   (rst_n),
    .din     (tx_fifo_din),
    .write   (tx_fifo_write),
    .dout    (tx_fifo_dout),
    .read    (tx_fifo_read),
    .wr_cnt  (),
    .rd_cnt  (),
    .data_cnt(),
    .full    (),
    .empty   (tx_fifo_empty)
  );

  ScFifo2 #(
      .DW(9),
      .AW(4)
  ) theRxFifo (
    .clk     (clk),
    .rst_n   (rst_n),
    .din     (rx_fifo_din),
    .write   (rx_fifo_write),
    .dout    (rx_fifo_dout),
    .read    (rx_fifo_read),
    .wr_cnt  (),
    .rd_cnt  (),
    .data_cnt(rx_fifo_dc),
    .full    (),
    .empty   ()
  );

  logic start, uart, tx_busy, rx_busy, par_err;
  assign tx_fifo_read = ~tx_fifo_empty & ~tx_busy & ~start;
  always_ff @(posedge clk) start <= tx_fifo_read;
  UartTx #(
      .BR_DIV(108),
      .PARITY(1)
  ) theUartTx (
    clk,
    rst,
    tx_fifo_dout,
    start,
    tx_busy,
    uart
  );
  UartRx #(
      .BR_DIV(109),
      .PARITY(1)
  ) theUartRx (
    clk,
    rst,
    uart,
    rx_fifo_din[7:0],
    rx_fifo_write,
    rx_fifo_din[8],
    rx_busy
  );

  initial begin
    repeat (100) @(posedge clk);
    @(posedge clk) {tx_fifo_write, tx_fifo_din} = {1'b1, 8'ha5};
    @(posedge clk) {tx_fifo_write, tx_fifo_din} = {1'b1, 8'hc3};
    @(posedge clk) tx_fifo_write = 1'b0;
    repeat (2500) @(posedge clk);
    @(posedge clk) {tx_fifo_write, tx_fifo_din} = {1'b1, 8'h37};
    @(posedge clk) tx_fifo_write = 1'b0;
    #100 $stop();
  end

  initial begin
    wait (rx_fifo_dc >= 4'd3);
    repeat (3) begin
      @(posedge clk) rx_fifo_read = 1'b1;
    end
    @(posedge clk) rx_fifo_read = 1'b0;
    repeat (100) @(posedge clk);
    $stop();
  end

endmodule

