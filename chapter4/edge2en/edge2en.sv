
`include "../common.sv"

`timescale 1ns / 1ps `default_nettype none
module TestEdge2En;
  import SimSrcGen::*;
  logic clk;
  initial GenClk(clk, 2, 10);
  logic in;
  initial begin
    in = 0;
    #44 in = 1;
    #56 in = 0;
  end
  logic en0, en1, en2;
  Rising2En #(0) theR2E0 (
    clk,
    in,
    en0,
  );
  Rising2En theR2E1 (
    clk,
    in,
    en1,
  );
  Rising2En #(2) theR2E2 (
    clk,
    in,
    en2,
  );
endmodule




