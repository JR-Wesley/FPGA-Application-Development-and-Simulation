`ifndef _SDPRAMRA_SV__
`define _SDPRAMRA_SV__

// simple double port RAM, read after
// asynchronous read
module SdpRamRa #(
    parameter integer DW    = 8,
    parameter integer WORDS = 256
) (
  input  wire                          clk,
  // write port
  input  wire  [$clog2(WORDS) - 1 : 0] addr_a,
  input  wire                          wr_a,
  input  wire  [           DW - 1 : 0] din_a,
  // read port
  input  wire  [$clog2(WORDS) - 1 : 0] addr_b,
  output logic [           DW - 1 : 0] qout_b
);

  logic [WORDS - 1 : 0][DW - 1 : 0] ram;

  always_ff @(posedge clk) begin
    if (wr_a) ram[addr_a] <= din_a;
  end

  assign qout_b = ram[addr_b];

endmodule

`endif
