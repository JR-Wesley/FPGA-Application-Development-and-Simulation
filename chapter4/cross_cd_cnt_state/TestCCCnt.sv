`timescale 1ns / 100ps

`include "./CrossClkCnt.sv"

module TestCCCnt;

  logic clk_a, clk_b;
  logic rst_n_a = 1'b0, rst_n_b = 1'b0;
  initial begin
    #20;
    rst_n_a = 1'b1;
    rst_n_b = 1'b1;
  end
  initial begin
    #2 clk_a = 0;
    forever #5 clk_a = ~clk_a;
  end
  initial begin
    #1 clk_b = 0;
    forever #4.5 clk_b = ~clk_b;
  end

  logic inc = 0;
  initial forever #10 inc = 1'($urandom());
  logic [7:0] cnt_a, cnt_b;

  CrossClkCnt theCCCnt (.*);

endmodule

