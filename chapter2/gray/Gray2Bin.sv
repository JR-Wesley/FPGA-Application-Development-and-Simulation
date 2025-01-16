`ifndef __GRAY2BIN_SV__
`define __GRAY2BIN_SV__

// Bin - Gray
//00-00,
//01-01,
//10-11,
//11-10
module Gray2Bin #(
    parameter int DW = 8
) (
  input  logic [DW-1:0] gray,
  output logic [DW-1:0] bin
);
  // two style

  // generate
  //   for (genvar i = 0; i < DW; i++) begin : g_binbits
  //     assign bin[i] = ^gray[DW-1:i];
  //   end
  // endgenerate

  always_comb begin : gray2bin
    for (int i = 0; i < DW; i++) bin[i] = ^(gray >> i);
  end

endmodule

`endif
