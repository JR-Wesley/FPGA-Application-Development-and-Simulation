`timescale 1ns / 100ps

`include "./Counter.sv"

module TestCounter;
  initial $dumpvars(0, TestCounter);
  initial #1000 $finish;

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;

  logic en = 1'b1;
  initial begin
    #100 en = 1'b0;
    #100 en = 1'b1;
  end

  localparam int unsigned M = 32;
  logic [$clog2(M) - 1 : 0] cnt;
  logic co;
  Counter #(M) theCnt (.*);

  initial if (co) assert (cnt == M - 1);

endmodule

