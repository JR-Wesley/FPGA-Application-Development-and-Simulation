
`ifndef _DPRAM_SV__
`define _DPRAM_SV__

// single port RAM, read first, sine table
module SpRamRfSine #(
    parameter integer DW    = 8,
    parameter integer WORDS = 256
    // parameter string  INIT_FILE = "sindata8b256.dat"
) (
  input  wire                                 clk,
  input  wire         [$clog2(WORDS) - 1 : 0] addr,
  input  wire                                 we,
  input  wire signed  [           DW - 1 : 0] din,
  output logic signed [           DW - 1 : 0] qout
);
  logic signed [WORDS - 1 : 0][DW - 1 : 0] ram;

  localparam real PI = 3.1415926535897932;
  initial begin
    for (int i = 0; i < WORDS; i++) begin
      ram[i] = $sin(2.0 * PI * i / WORDS) * (2 ** (DW - 1) - 1);
    end
    // $readmemh(INIT_FILE, ram);
  end

  always @(posedge clk) begin
    if (we) ram[addr] <= din;
    qout <= ram[addr];
  end

endmodule

`endif
