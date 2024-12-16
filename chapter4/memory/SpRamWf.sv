
`ifndef _SPRAMWF_SV__
`define _SPRAMWF_SV__

// single port RAM, write first
module SpRamWf #(
    parameter integer DW    = 8,
    parameter integer WORDS = 256
) (
  input  wire                          clk,
  input  wire  [$clog2(WORDS) - 1 : 0] addr,
  input  wire                          we,
  input  wire  [           DW - 1 : 0] din,
  output logic [           DW - 1 : 0] qout
);

  logic [WORDS - 1 : 0][DW - 1 : 0] ram;

  always_ff @(posedge clk) begin
    if (we) ram[addr] <= din;
  end

  always_ff @(posedge clk) begin
    if (we) qout <= din;
    else qout <= ram[addr];
  end

endmodule

`endif
