`ifndef __RECFG_DELAY_CHAIN_SV__
`define __RECFG_DELAY_CHAIN_SV__

`include "../memory/SpRamRf.sv"

// reconfigurable delay chain with dynamic length
// when lenght change, after new length latched by clock,
// the dout data of the new length quantity will be unreliable.
module RecfgDelayChain #(
    parameter integer DW      = 8,
    parameter integer MAX_LEN = 32,
    parameter integer MIN_LEN = 2
) (
  input  wire                            clk,
  input  wire                            rst_n,
  input  wire                            en,
  input  wire  [$clog2(MAX_LEN+1)-1 : 0] length,
  input  wire  [             DW - 1 : 0] din,
  output logic [             DW - 1 : 0] dout
);

  logic en_dly;
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) en_dly <= '0;
    else en_dly <= en;
  end

  logic [DW - 1 : 0] din_dly;
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) din_dly <= '0;
    else if (en) din_dly <= din;
  end

  logic [DW - 1 : 0] ram_out, ram_out_dly;
  logic [$clog2(MAX_LEN)-1 : 0] addr;
  SpRamRf #(
      .DW(DW),
      .WORDS(MAX_LEN)
  ) theRam (
      .clk (clk),
      .addr(addr),
      .we  (en),
      .din (din),
      .qout(ram_out)
  );

  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) ram_out_dly <= '0;
    else if (en_dly) ram_out_dly <= ram_out;
  end

  generate
    if (MIN_LEN > 1) begin : g_case_1
      assign dout = en_dly ? ram_out : ram_out_dly;
    end else if (MIN_LEN > 0) begin : g_case_2
      assign dout = length == 'd1 ? din_dly : en_dly ? ram_out : ram_out_dly;
    end else begin : g_case_3
      assign dout = length == 'd0 ? din : length == 'd1 ? din_dly : en_dly ? ram_out : ram_out_dly;
    end
  endgenerate

  logic [$clog2(MAX_LEN)-1 : 0] addr_next;
  assign addr_next = (addr < length - 'd2) ? addr + 1'b1 : '0;
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) addr <= '0;
    else if (en) addr <= addr_next;
  end

endmodule

`endif
