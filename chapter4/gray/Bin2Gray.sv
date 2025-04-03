`ifndef __BIN2GRAY_SV__
`define __BIN2GRAY_SV__

module Bin2Gray #(
    parameter int DW = 8
) (
  input  logic              clk,
  input  logic [DW - 1 : 0] bin,
  output logic [DW - 1 : 0] gray
);

  always_ff @(posedge clk) begin
    gray <= bin ^ (bin >> 1);
  end

endmodule

`endif
