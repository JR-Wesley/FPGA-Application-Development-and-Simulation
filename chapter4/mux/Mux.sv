
module Mux #(
    parameter int unsigned DW = 8,
    parameter int unsigned CH = 4
) (
    input  wire  [        DW - 1 : 0] in [CH],
    input  wire  [$clog2(CH) - 1 : 0] sel,
    output logic [        DW - 1 : 0] out
);

  assign out = in[sel];

endmodule

