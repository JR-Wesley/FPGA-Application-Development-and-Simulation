`timescale 1ns / 100ps
`include "./SpRamRfSine.sv"

module TestMemSine;
  initial $dumpvars(0, TestMemSine);
  initial #50000 $finish;

  logic clk = 1'b0;
  initial forever #5 clk = ~clk;

  logic [7 : 0] a = 0, d = 0;
  logic [7 : 0] q;
  logic we = 0;

  initial begin
    #10{we, a, d} = {1'b1, 8'h01, 8'h10};
    #10{we, a, d} = {1'b1, 8'h03, 8'h30};
    #10{we, a, d} = {1'b1, 8'h06, 8'h60};
    #10{we, a, d} = {1'b1, 8'h0a, 8'ha0};
    #10{we, a, d} = {1'b1, 8'h0f, 8'hf0};
    #10{we, a, d} = {1'b0, 8'h00, 8'h00};
    forever #10 a++;
    // Within `GTKWave`, toggle `analog` data format and
    // insert analog height extension to show the analog wave.
  end

  SpRamRfSine theMem (
    .clk (clk),
    .addr(a),
    .we  (we),
    .din (d),
    .qout(q)
  );

endmodule

