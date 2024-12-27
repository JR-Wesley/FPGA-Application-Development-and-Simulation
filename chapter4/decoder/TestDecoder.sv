`timescale 1ns / 100ps

`include "Decoder.sv"

module TestDecoder;
  initial $dumpvars(0, TestDecoder);
  initial #200 $finish;

  logic [2:0] a = '0;
  logic [7:0] y;
  initial forever #10 a++;

  Decoder #(3) theDec (
      .in (a),
      .out(y)
  );

endmodule
