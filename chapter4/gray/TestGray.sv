`include "./Gray2Bin.sv"
`include "./Bin2Gray.sv"

// ====== code 3-10 ======
module TestGray;
  initial $dumpvars(0, TestGray);
  initial #100 $finish;

  logic clk = 1'b0;
  initial forever #5 clk = ~clk;

  localparam int DW = 6;
  logic [DW-1 : 0] bin = '0;
  logic [DW-1 : 0] bin_re;
  initial forever #10 bin++;
  logic [DW-1 : 0] gray;

  Bin2Gray #(.DW(DW)) the_b2g (.*);
  Gray2Bin #(
      .DW(DW)
  ) the_g2b (
    .gray(gray),
    .bin (bin_re)
  );

endmodule

