`ifndef _BF2_SV__
`define _BF2_SV__

`include "./R2SdfDefinesPkg.sv"

module Bf2
  import R2SdfDefinesPkg::*;
(
  input  Cplx x0,
  input  Cplx x1,
  output Cplx z0,
  output Cplx z1,
  input  wire s,
  input  wire scale
);

  always_comb z0 = ~s ? x0 : cadd(x0, x1, scale);
  always_comb z1 = ~s ? x1 : csub(x0, x1, scale);

endmodule

`endif
