`timescale 1ns / 100ps

`include "../../SimSrcGen.sv"
`include "CrossClkCnt.sv"

module TestCCCnt;
  import SimSrcGen::*;
  logic clk_a, clk_b;
  initial GenClk(clk_a, 2, 10);
  initial GenClk(clk_b, 1, 9);

  logic inc = 0;
  initial forever #10 inc = 1'($urandom());
  logic [7:0] cnt_a, cnt_b;

  CrossClkCnt theCCCnt (
    .*,
    .rst_a(1'b0),
    .rst_b(1'b0)
  );

endmodule

