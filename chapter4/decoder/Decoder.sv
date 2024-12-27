
module Decoder #(
    parameter int unsigned INW = 4
) (
    input  logic [   INW - 1 : 0] in,
    output logic [2**INW - 1 : 0] out
);

  assign out = (2 ** INW)'(1) << in;

endmodule
