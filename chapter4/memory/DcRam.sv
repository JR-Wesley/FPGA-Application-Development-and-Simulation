`ifndef _DCRAM_SV__
`define _DCRAM_SV__

// double clock port RAM
module DcRam #(
    parameter int  DW    = 8,
    parameter int  WORDS = 256,
    parameter type dw_t  = logic [           DW - 1 : 0],
    parameter type aw_t  = logic [$clog2(WORDS) - 1 : 0]
) (
  // port a
  input  logic clk_a,
  input  aw_t  addr_a,
  input  logic wr_a,
  input  dw_t  din_a,
  output dw_t  qout_a,
  // port b
  input  logic clk_b,
  input  aw_t  addr_b,
  input  logic wr_b,
  input  dw_t  din_b,
  output dw_t  qout_b
);

  dw_t ram[WORDS];

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
