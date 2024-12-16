`ifndef _DCRAM_SV__
`define _DCRAM_SV__

// double clock port RAM
module DcRam #(
    parameter integer DW    = 8,
    parameter integer WORDS = 256
) (
  // port a
  input  wire                          clk_a,
  input  wire  [$clog2(WORDS) - 1 : 0] addr_a,
  input  wire                          wr_a,
  input  wire  [           DW - 1 : 0] din_a,
  output logic [           DW - 1 : 0] qout_a,
  // port b
  input  wire                          clk_b,
  input  wire  [$clog2(WORDS) - 1 : 0] addr_b,
  input  wire                          wr_b,
  input  wire  [           DW - 1 : 0] din_b,
  output logic [           DW - 1 : 0] qout_b
);

  logic [WORDS - 1 : 0][DW - 1 : 0] ram;

  always_ff @(posedge clk_a) begin
    if (wr_a) ram[addr_a] <= din_a;
    qout_a <= ram[addr_a];
  end

  always_ff @(posedge clk_b) begin
    if (wr_b) ram[addr_b] <= din_b;
    qout_b <= ram[addr_b];
  end

endmodule

`endif
