`timescale 1ns / 1ps
`include "./PulseWiden.sv"

module TestPulseWiden;
  initial $dumpvars(0, TestPulseWiden);
  initial #300 $finish;

  logic clk = 1'b0;
  initial forever #5 clk = ~clk;

  logic in;
  initial begin
    in = 0;
    #44 in = 1;
    #56 in = 0;
    #100 in = 1;
    #10 in = 0;
  end

  logic out4, out2, out3;
  PulseWiden #(4) pw1 (
    .*,
    .out(out4)
  );
  PulseWiden #(2) pw2 (
    .*,
    .out(out2)
  );

  PulseWiden #(3) pw3 (
    .*,
    .out(out3)
  );

endmodule
