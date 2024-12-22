`timescale 1ns / 100ps
`include "./DelayChainMemPre.sv"
`include "./DelayChainMem.sv"

`default_nettype none

module TestDelayChainMem;
  initial begin
    $dumpfile("TestDelayChainMem.fst");
    $dumpvars(0, TestDelayChainMem);
  end

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;
  initial #400 $finish;

  logic [7:0] a;
  logic [7:0] y_unopt, y;
  logic en = 0;

  initial begin
    #30 en = '1;
    #120 en = '0;
    #20 en = '1;
  end

  initial forever #10 a = 8'($urandom());

  DelayChainMemPre #(
      .DW(8),
      .LEN(5)
  ) dcmempre (
      .clk  (clk),
      .rst_n(rst_n),
      .en   (en),
      .din  (a),
      .dout (y_unopt)
  );

  DelayChainMem #(
      .DW(8),
      .LEN(5)
  ) dcmem (
      .clk  (clk),
      .rst_n(rst_n),
      .en   (en),
      .din  (a),
      .dout (y)
  );

endmodule

