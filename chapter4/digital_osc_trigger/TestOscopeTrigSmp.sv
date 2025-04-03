`timescale 1ns / 100ps

`include "../../SimSrcGen.sv"

module TestOscopeTrigSmp;
  import SimSrcGen::*;
  logic clk, rst;
  initial GenClk(clk, 8, 10);
  initial GenRst(clk, rst, 1, 1);
  logic smpEn;
  Counter #(4) theSmpRateGen (
    clk,
    rst,
    1'b1
    ,,
    smpEn
  );
  logic [7:0] addr;
  Counter #(256) theSigGenAddr (
    clk,
    rst,
    smpEn,
    addr,
  );
  logic signed [7:0] sig, dout;
  SpRamRfSine theSig (
    clk,
    addr,
    1'b0,
    8'b0,
    sig
  );
  logic start = '0, read = '0;
  logic signed [7:0] level = '0;
  logic [9:0] hpos = 10'd500;
  logic [26:0] to = '0;
  logic busy, trig_flag;
  OscopeTrigSmp theOscpTrigSmp (
    clk,
    rst,
    sig,
    smpEn,
    start,
    level,
    hpos,
    to,
    dout,
    read,
    busy,
    trig_flag
  );
  initial begin
    repeat (5) @(posedge clk);
    @(posedge clk) {start, level, hpos, to} <= {'1, 8'sd100, 10'd250, 27'd300};
    @(posedge clk) start <= '0;
    @(negedge busy);
    repeat (1000) @(posedge clk) read = '1;
    @(posedge clk) read = '0;
    //
    @(posedge clk) {start, level, hpos, to} <= {'1, 8'sd50, 10'd250, 27'd0};
    @(posedge clk) start <= '0;
    @(negedge busy);
    repeat (1000) @(posedge clk) read = '1;
    @(posedge clk) read = '0;
    //
    @(posedge clk) {start, level, hpos, to} <= {'1, -8'sd128, 10'd250, 27'd300};
    @(posedge clk) start <= '0;
    @(negedge busy);
    repeat (1000) @(posedge clk) read = '1;
    @(posedge clk) read = '0;
    //
    @(posedge clk) {start, level, hpos, to} <= {'1, -8'sd128, 10'd750, 27'd300};
    @(posedge clk) start <= '0;
    @(negedge busy);
    repeat (1000) @(posedge clk) read = '1;
    @(posedge clk) read = '0;
    //
    @(posedge clk) $stop();
  end
endmodule
