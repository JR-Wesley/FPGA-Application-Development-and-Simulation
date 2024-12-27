`timescale 1ns / 100ps

`include "Mux.sv"

module TestMux;
  initial $dumpvars(0, TestMux);
  initial #4000 $finish;

  logic [7:0] a[4], y;
  logic [1:0] sel = '0;

  initial begin
    a[0] = 0;
    a[1] = 0;
    a[2] = 0;
    a[3] = 0;
    forever begin
      #10 a[0]++;
      #20 a[1]++;
      #40 a[2]++;
      #80 a[3]++;
      #160 sel++;
    end
  end

  logic [32 : 0] in;
  assign in = {a[3], a[2], a[1], a[0]};

  Mux #() theMux (
      .in (a),
      .sel(sel),
      .out(y)
  );

endmodule

