`ifndef __FALLING2EN_SV__
`define __FALLING2EN_SV__

module Falling2En #(
    parameter int unsigned SYNC_STG = 1
) (
  input  logic clk,
  input  logic in,
  output logic en,
  output logic out
);

  logic [SYNC_STG : 0] dly;
  always_ff @(posedge clk) begin
    dly <= {dly[SYNC_STG-1 : 0], in};
  end

  assign en = (SYNC_STG ? dly[SYNC_STG-:2] : {dly, in}) == 2'b10;
  assign out = dly[SYNC_STG];

endmodule

`endif
