`ifndef __DELAY_CHAIN_MEM_SV__
`define __DELAY_CHAIN_MEM_SV__

`include "../memory/SpRamRf.sv"

// improved output behavior (just like scfifo2)
module DelayChainMem #(
    parameter integer DW  = 8,
    parameter integer LEN = 32
) (
  input  wire               clk,
  input  wire               rst_n,
  input  wire               en,
  input  wire  [DW - 1 : 0] din,
  output logic [DW - 1 : 0] dout
);

  generate
    if (LEN == 0) begin : g_zero_delay
      assign dout = din;

    end else if (LEN == 1) begin : g_one_delay
      always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) dout <= '0;
        else if (en) dout <= din;
      end

    end else begin : g_delay
      // NOTE: logic improved
      // When `en` is clear, the output should be zero.
      logic en_dly;
      always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) en_dly <= '0;
        else en_dly <= en;
      end

      logic [$clog2(LEN) - 1 : 0] addr;
      logic [DW - 1:0] ram_out, ram_out_dly;
      SpRamRf #(
          .DW(DW),
          .WORDS(LEN)
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
      assign dout = en_dly ? ram_out : ram_out_dly;

      logic [$clog2(LEN) - 1 : 0] addr_next;
      assign addr_next = (addr < LEN - 2) ? addr + 1'b1 : '0;
      always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) addr <= '0;
        else if (en) addr <= addr_next;
      end

    end
  endgenerate

endmodule

`endif
