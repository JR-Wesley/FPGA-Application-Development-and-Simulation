`ifndef _DPRAM_SV__
`define _DPRAM_SV__

// Double port RAM
module DpRam #(
    parameter integer DW    = 8,
    parameter integer WORDS = 256
) (
  input  wire                          clk,
  // port a
  input  wire  [$clog2(WORDS) - 1 : 0] addr_a,
  input  wire                          wr_a,
  input  wire  [           DW - 1 : 0] din_a,
  output logic [           DW - 1 : 0] qout_a,
  // port b
  input  wire  [$clog2(WORDS) - 1 : 0] addr_b,
  input  wire                          wr_b,
  input  wire  [           DW - 1 : 0] din_b,
  output logic [           DW - 1 : 0] qout_b
);

  logic [WORDS - 1 : 0][DW - 1 : 0] ram;

  // If two ports write to one address, the result is uncertain.
  // Avoid this situation.
  always_ff @(posedge clk) begin
    if (wr_a) begin
      ram[addr_a] <= din_a;
      qout_a <= din_a;
    end else qout_a <= ram[addr_a];
  end

  always_ff @(posedge clk) begin
    if (wr_b) begin
      ram[addr_b] <= din_b;
      qout_b <= din_b;
    end else qout_b <= ram[addr_b];
  end

endmodule

`endif
