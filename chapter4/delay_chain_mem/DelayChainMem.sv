`ifndef __DELAY_CHAIN_MEM_SV__
`define __DELAY_CHAIN_MEM_SV__

`include "../memory/SpRamRf.sv"

// improved output behavior (just like scfifo2)
module DelayChainMem #(
    parameter int  DW   = 8,
    parameter int  LEN  = 4,
    parameter type dw_t = logic [         DW - 1 : 0],
    parameter type aw_t = logic [$clog2(LEN) - 1 : 0]
) (
  input  logic clk,
  input  logic rst_n,
  input  logic en,
  input  dw_t  din,
  output dw_t  dout
);
  `define FFARNE(__q, __d, __en, __clk, __arst_n) \
  always_ff @(posedge (__clk), negedge (__arst_n)) begin \
    if (!__arst_n) __q <= '0; \
    if (__en) __q <= (__d); \
  end

  generate
    if (LEN == 0) begin : g_zero_delay
      assign dout = din;

    end else if (LEN == 1) begin : g_one_delay
      `FFARNE(dout, din, 1'b1, clk, rst_n)

    end else begin : g_delay
      // NOTE: logic improved
      // When `en` is clear, the output should be zero.
      logic en_dly;
      `FFARNE(en_dly, en, 1'b1, clk, rst_n)

      aw_t addr;
      dw_t ram_out, ram_out_dly;
      SpRamRf #(
          .DW   (DW),
          .WORDS(LEN)
      ) theRam (
        .*,
        .we  (en),
        .qout(ram_out)
      );
      `FFARNE(ram_out_dly, ram_out, en_dly, clk, rst_n)
      assign dout = en_dly ? ram_out : ram_out_dly;

      aw_t addr_next;
      assign addr_next = (addr < LEN - 2) ? addr + 1'b1 : '0;
      `FFARNE(addr, addr_next, en, clk, rst_n)

    end
  endgenerate

endmodule

`endif
