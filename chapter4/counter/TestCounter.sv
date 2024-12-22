`timescale 1ns / 100ps
`include "./Counter.sv"

`default_nettype none

module TestCounter;
  initial begin
    $dumpfile("TestCounter.fst");
    $dumpvars(0, TestCounter);
  end

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;
  initial #2000 $finish;

  logic en;
  initial begin
    en = 1'b1;
    #100 en = 1'b0;
    #100 en = 1'b1;
  end

  localparam integer M = 32;
  logic [$clog2(M) - 1 : 0] cnt;
  logic co;
  Counter #(M) theCnt (
      .clk  (clk),
      .rst_n(rst_n),
      .en   (en),
      .cnt  (cnt),
      .co   (co)
  );

  initial if (co) assert (cnt == M - 1);

endmodule

