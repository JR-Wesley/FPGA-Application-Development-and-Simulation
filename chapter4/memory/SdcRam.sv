`ifndef _SDCRAM_SV__
`define _SDCRAM_SV__

// Simple double clock RAM
module SdcRam #(
    parameter int unsigned WORDS = 256,
    parameter int unsigned DW    = 8,
    parameter type         aw_t  = logic [$clog2(WORDS) - 1 : 0],
    parameter type         dw_t  = logic [           DW - 1 : 0]
) (
    // write port
    input  logic clk_a,
    input  aw_t  addr_a,
    input  logic wr_a,
    input  dw_t  din_a,
    // read port
    input  logic clk_b,
    input  aw_t  addr_b,
    output dw_t  qout_b
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
