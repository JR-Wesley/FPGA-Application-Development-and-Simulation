
// ====== code 3-10 ======
module code3_10;
  import simSrcGen::genClk;
  logic clk;
  initial genClk(clk, 2.5, 10);
  logic [5:0] bin = '0;
  always #10 bin++;
  logic [5:0] gray;
  bin2gray #(6) the_b2g (
    clk,
    bin,
    gray
  );
endmodule
module bin2gray #(
    parameter DW = 8
) (
  input  wire               clk,
  input  wire  [DW - 1 : 0] bin,
  output logic [DW - 1 : 0] gray
);
  always_ff @(posedge clk) begin
    gray <= bin ^ (bin >> 1);
  end
endmodule
// ====== end of code 3-10 ======
