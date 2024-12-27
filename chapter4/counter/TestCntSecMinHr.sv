`timescale 1ns / 100ps

`include "./CntSecMinHr.sv"

module TestCntSecMinHr;
  initial $dumpvars(0, TestCntSecMinHr);
  initial #30000 $finish;

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;

  logic [5:0] sec, min;
  logic [4:0] hr;
  CntSecMinHr theCntSMH (.*);

endmodule
