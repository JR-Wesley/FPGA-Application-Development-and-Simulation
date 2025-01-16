`ifndef __ENCODER_SV__
`define __ENCODER_SV__

module Encoder #(
    parameter int OUTW = 4
) (
  input  logic [2**OUTW - 1 : 0] in,
  output logic [   OUTW - 1 : 0] out
);

  always_comb begin
    out = '0;
    for (int i = 2 ** OUTW - 1; i >= 0; i--) begin
      if (in[i]) out = OUTW'(i);
    end
  end

endmodule

`endif
