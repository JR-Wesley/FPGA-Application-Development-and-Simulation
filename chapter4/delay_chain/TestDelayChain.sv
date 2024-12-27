`timescale 1ns / 100ps
`include "./DelayChain.sv"

`default_nettype none

module TestDelayChain;
  initial $dumpvars(0, TestDelayChain);
  initial #200 $finish;

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;

  logic en = 1'b1;
  localparam int unsigned DW = 8;
  logic [DW - 1 : 0] a, y;
  initial forever #10 a = DW'($urandom());

  DelayChain #(
      .DW(8),
      .LEN(5)
  ) dc (
      .*,
      .in (a),
      .out(y)
  );

endmodule

