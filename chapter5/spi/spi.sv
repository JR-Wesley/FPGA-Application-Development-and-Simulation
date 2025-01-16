`timescale 1ns / 100ps

`include "../common.sv"
`include "../chapter4/counter.sv"

`default_nettype none

module TestSpi;
  import SimSrcGen::*;
  logic clk, rst;
  initial GenClk(clk, 8, 10);
  initial GenRst(clk, rst, 1, 1);
  logic [7:0] mtx_data[6] = '{8'hff, 8'ha5, 8'h3c, 8'h5a, 8'h0f, 8'hf0};
  logic [7:0] mrx_data[6];
  logic [7:0] stx_data[6] = '{8'hff, 8'h33, 8'haa, 8'h55, 8'hff, 8'h00};
  logic [7:0] srx_data[6];
  logic start = '0, mread, sread, mvalid, svalid, mbusy, sbusy;
  logic [7:0] mtx_d, mrx_d, stx_d, srx_d;
  logic [23:0] ss_mask = '0, ss_n;
  logic [7:0] trans_len = '0;
  logic mmosi, mmosi_tri, smiso, smiso_tri;
  logic sclk0, mosi, miso;
  assign mosi = mmosi_tri ? 'z : mmosi;
  assign miso = smiso_tri ? 'z : smiso;
  SpiMaster #(4, 1) theMaster (
    clk,
    rst,
    start,
    ss_mask,
    trans_len,
    mread,
    mtx_d,
    mvalid,
    mrx_d,
    mbusy,
    sclk0
    ,,
    mmosi,
    mmosi_tri,
    miso,
    ss_n
  );
  SpiSlave #(1) theSlave (
    clk,
    rst,
    ss_n[3],
    sclk0,
    mosi,
    smiso,
    smiso_tri,
    sread,
    stx_d,
    svalid,
    srx_d,
    sbusy
  );
  initial begin
    repeat (10) @(posedge clk);
    @(posedge clk) {start, ss_mask, trans_len} = {1'b1, 24'd4, 8'd0};
    @(posedge clk) {start, ss_mask, trans_len} = {1'b0, 24'd0, 8'd0};
    @(posedge clk);
    wait (~mbusy);
    @(posedge clk) {start, ss_mask, trans_len} = {1'b1, 24'd8, 8'd0};
    @(posedge clk) {start, ss_mask, trans_len} = {1'b0, 24'd0, 8'd0};
    @(posedge clk);
    wait (~mbusy);
    @(posedge clk) {start, ss_mask, trans_len} = {1'b1, 24'd8, 8'd3};
    @(posedge clk) {start, ss_mask, trans_len} = {1'b0, 24'd0, 8'd0};
    @(posedge clk);
    wait (~mbusy);
    repeat (50) @(posedge clk);
    $stop();
  end
  logic [2:0] mtx_idx = '0, mrx_idx = '0, stx_idx = '0, srx_idx = '0;
  always_ff @(posedge clk) if (mread) mtx_d = mtx_data[mtx_idx++];
  always_ff @(posedge clk) if (sread) stx_d = stx_data[stx_idx++];
  always_ff @(posedge clk) if (mvalid) mrx_data[mrx_idx++] = mrx_d;
  always_ff @(posedge clk) if (svalid) srx_data[srx_idx++] = srx_d;
endmodule

