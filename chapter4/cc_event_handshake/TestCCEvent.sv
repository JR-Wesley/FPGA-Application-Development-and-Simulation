`timescale 1ns / 100ps

`include "./CrossClkEvent.sv"

module TestCCEvent;
  initial $dumpvars(0, TestCCEvent);
  initial #300 $finish;

  logic clk_a, clk_b;
  initial begin
    #2 clk_a = 0;
    forever #5 clk_a = ~clk_a;
  end
  initial begin
    #1 clk_b = 0;
    forever #6 clk_b = ~clk_b;
  end

  logic in = 0;
  initial begin
    #100 in = 1;
    #10 in = 0;
    #80 in = 1;
    #10 in = 0;
  end

  logic busy, out;
  CrossClkEvent theCCEvent (.*);

endmodule

