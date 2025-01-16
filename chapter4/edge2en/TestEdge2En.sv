`timescale 1ns / 100ps
`include "./Rising2En.sv"

module TestEdge2En;
  initial $dumpvars(0, TestEdge2En);
  initial #200 $finish;

  logic clk = 1'b0;
  initial forever #5 clk = ~clk;

  logic in;
  initial begin
    in = 0;
    #44 in = 1;
    #56 in = 0;
  end

  logic en0, en1, en2;
  Rising2En #(0) theR2E0 (
    .*,
    .en (en0),
    .out()
  );
  Rising2En theR2E1 (
    .*,
    .en (en1),
    .out()
  );
  Rising2En #(2) theR2E2 (
    .*,
    .en (en2),
    .out()
  );

endmodule




