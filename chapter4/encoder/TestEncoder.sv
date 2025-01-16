`timescale 1ns / 100ps

`include "./Encoder.sv"

module TestEncoder;
  initial $dumpvars(0, TestEncoder);
  initial #200 $finish;

  logic [7:0] a = '0;
  logic [2:0] y;
  initial forever #10 a++;

  Encoder #(3) theEnc (
    .in (a),
    .out(y)
  );
  // `DEF_PRIO_ENC(PrioEnc8to3, 3)
  // always_comb y = PrioEnc8to3(a);

endmodule

