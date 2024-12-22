`timescale 1ns / 100ps
`include "./Accumulator.sv"
`include "./AccuM.sv"

`default_nettype none

module TestAccu;
  initial begin
    $dumpfile("TestAccu.fst");
    $dumpvars(0, TestAccu);
  end

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;
  initial #400 $finish;

  // add `clr` signal for setting accumulator to zero
  logic clr = 1'b0;

  logic [15:0] d = '0, acc;
  initial forever #10 d++;

  Accumulator #(16) theAcc (
      .clk  (clk),
      .rst_n(rst_n),
      .clr  (clr),
      .en   (1'b1),
      .d    (d),
      .acc  (acc)
  );

  logic [5:0] dm = '0, accm;
  initial forever #10 dm++;

  localparam integer M = 50;
  AccuM #(M) theAccM (
      .clk  (clk),
      .rst_n(rst_n),
      .clr  (clr),
      .en   (1'b1),
      .d    (dm),
      .acc  (accm)
  );

  initial #10 assert (accm == (acc % M));

endmodule

