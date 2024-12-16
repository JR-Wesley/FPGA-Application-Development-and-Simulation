`timescale 1ns / 100ps
`include "./CntSecMinHr.sv"

`default_nettype none

module TestCntSecMinHr;
  initial begin
    $dumpfile("TestCntSecMinHr.vcd");
    $dumpvars(0, TestCntSecMinHr);
  end

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;
  initial #30000 $finish;

  logic [5:0] sec, min;
  logic [4:0] hr;
  CntSecMinHr theCntSMH (
      .clk  (clk),
      .rst_n(rst_n),
      .sec  (sec),
      .min  (min),
      .hr   (hr)
  );

endmodule
