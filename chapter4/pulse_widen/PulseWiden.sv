`ifndef __PULSEWIDEN_SV__
`define __PULSEWIDEN_SV__

module PulseWiden #(
    parameter int RATIO = 1
) (
  input  logic clk,
  input  logic in,
  output logic out
);
  logic [$clog2(RATIO + 1) - 1 : 0] cnt = '0;
  always_ff @(posedge clk) begin
    if (in) cnt <= RATIO;
    else if (cnt > 0) cnt <= cnt - 1'b1;
  end
  assign out = cnt > 0;

endmodule

`endif
