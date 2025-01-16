`timescale 1ns / 100ps

`include "../../SimSrcGen.sv"

module TestScFifo;
  import SimSrcGen::*;
  logic clk;
  initial GenClk(clk, 8, 10);

  logic [7:0] din = '0, dout;
  logic wr = '0, rd = '0;
  logic [2:0] wr_cnt, rd_cnt, data_cnt;
  logic full, empty;

  initial begin
    for (int i = 0; i < 10; i++) begin
      @(posedge clk) {wr, din} = {1'b1, 8'($urandom())};
    end
    @(posedge clk) wr = 1'b0;
    for (int i = 0; i < 10; i++) begin
      @(posedge clk) rd = 1'b1;
    end
    @(posedge clk) rd = 1'b0;
    for (int i = 0; i < 5; i++) begin
      @(posedge clk) {wr, din} = {1'b1, 8'($urandom())};
    end
    @(posedge clk) wr = 1'b0;
    for (int i = 0; i < 5; i++) begin
      @(posedge clk) rd = 1'b1;
    end
    @(posedge clk) rd = 1'b0;
    for (int i = 0; i < 5; i++) begin
      @(posedge clk) {wr, din} = {1'b1, 8'($urandom())};
    end
    @(posedge clk) wr = 1'b0;
    for (int i = 0; i < 5; i++) begin
      @(posedge clk) rd = 1'b1;
    end
    @(posedge clk) rd = 1'b0;
    #10 $stop();
  end

  ScFifo2 #(
      .DW(8),
      .AW(3)
  ) theFifo (
    .*,
    .rst_n(1'b0),
    .write(wr & ~full),
    .read (rd & ~empty)
  );

endmodule
