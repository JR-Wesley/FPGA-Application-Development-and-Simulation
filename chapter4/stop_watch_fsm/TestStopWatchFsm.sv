`timescale 1ms / 1us
`include "../../SimSrcGen.sv"
`include "../counter/Counter.sv"
`include "../key_process/KeyProcess.sv"
`include "StopWatchFsm.sv"

module TestStopWatchFsm;

  import SimSrcGen::*;
  logic clk, rst;
  initial GenClk(clk, 8, 1);  // period 1ns
  initial GenRst(clk, rst, 1, 1);
  logic rst_n;
  assign rst_n = ~rst;

  logic k0 = '0, k1 = '0;

  initial begin
    #200 KeyPress(k0, 50);  //start
    #450 KeyPress(k0, 50);  //pause
    #220 KeyPress(k1, 50);  //stop
    #260 KeyPress(k0, 50);  //start
    #450 KeyPress(k1, 50);  //freeze
    #680 KeyPress(k1, 50);  //freeze
    #990 KeyPress(k0, 50);  //run
    #220 KeyPress(k0, 50);  //pause
    #120 KeyPress(k1, 50);  //stop
    #100 $finish();
  end

  logic k0en, k1en;
  KeyProcess #(
      .SMP_INTV(10),
      .KEY_NUM (2)
  ) key2en (
    .clk   (clk),
    .key   ({k1, k0}),
    .key_en({k1en, k0en})
  );

  logic t, f, r, u;
  StopWatchFsm sw_sm (
    .*,
    .k0      (k0en),
    .k1      (k1en),
    .timming (t),
    .freezing(f),
    .reset   (r),
    .update  (u)
  );

  logic en_10ms;
  Counter #(10) cntClk (
    .*,
    .rst_n(rst_n & ~r),
    .en   (t),
    .cnt  (),
    .co   (en_10ms)
  );

  logic en_1sec, en_1min;
  logic [6:0] cnt_centisec;
  logic [5:0] cnt_sec;
  Counter #(100) cntCentiSec (
    .*,
    .rst_n(rst_n & ~r),
    .en   (en_10ms),
    .cnt  (cnt_centisec),
    .co   (en_1sec)
  );
  Counter #(60) cntSec (
    .*,
    .rst_n(rst_n & ~r),
    .en   (en_1sec),
    .cnt  (cnt_sec),
    .co   (en_1min)
  );

  logic [6:0] centisec;
  logic [5:0] sec;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      centisec <= 7'b0;
      sec <= 6'b0;
    end else if (~f | u) begin
      centisec <= cnt_centisec;
      sec <= cnt_sec;
    end
  end

endmodule

