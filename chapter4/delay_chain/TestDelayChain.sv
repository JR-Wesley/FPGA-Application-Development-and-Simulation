`timescale 1ns / 100ps
`include "./DelayChain.sv"

`default_nettype none

module TestDelayChain;
  initial begin
    $dumpfile("TestDelayChain.fst");
    $dumpvars(0, TestDelayChain);
  end

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;
  initial #400 $finish;

  localparam integer DW = 8;
  logic [DW - 1 : 0] a, y;
  always #10 a <= DW'($urandom());

  DelayChain #(
      .DW(8),
      .LEN(5)
  ) dc (
      .clk  (clk),
      .rst_n(rst_n),
      .en   (1'b1),
      .in   (a),
      .out  (y)
  );

endmodule

