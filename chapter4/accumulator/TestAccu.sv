`timescale 1ns / 100ps

`include "Accumulator.sv"
`include "AccuM.sv"

module TestAccu;
  initial $dumpvars(0, TestAccu);
  initial #400 $finish;

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;

  logic en = 1'b1;
  logic [15:0] d = '0, acc;
  initial forever #10 d++;

  Accumulator #(16) theAcc (.*);

  logic [5:0] dm = '0, accm;
  initial forever #10 dm++;

  localparam int unsigned M = 50;
  AccuM #(M) theAccM (.*);

  initial forever #10 assert (accm == (acc % M));

endmodule

