`ifndef _SDCRAM_SV__
`define _SDCRAM_SV__

// Simple double clock RAM
module SdcRam #(
    parameter integer DW    = 8,
    parameter integer WORDS = 256
) (
  // write port
  input  wire                          clk_a,
  input  wire  [$clog2(WORDS) - 1 : 0] addr_a,
  input  wire                          wr_a,
  input  wire  [           DW - 1 : 0] din_a,
  // read port
  input  wire                          clk_b,
  input  wire  [$clog2(WORDS) - 1 : 0] addr_b,
  output logic [           DW - 1 : 0] qout_b
);

  logic [WORDS - 1 : 0][DW - 1 : 0] ram;

  always_ff @(posedge clk_a) begin
    if (wr_a) ram[addr_a] <= din_a;
  end

  always_ff @(posedge clk_b) begin
    qout_b <= ram[addr_b];
  end

endmodule

`endif
