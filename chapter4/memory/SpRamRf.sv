`ifndef _SPRAMRF_SV__
`define _SPRAMRF_SV__

// single port RAM, read first
module SpRamRf #(
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
    qout <= ram[addr];
  end

endmodule

`endif
