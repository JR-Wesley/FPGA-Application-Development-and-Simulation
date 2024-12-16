`ifndef __DELAY_CHAIN_MEM_PRE_SV__
`define __DELAY_CHAIN_MEM_PRE_SV__

`include "../memory/SpRamRf.sv"

module DelayChainMemPre #(
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
      logic [$clog2(LEN) - 1 : 0] addr;
      SpRamRf #(
          .DW(DW),
          .WORDS(LEN)
      ) theRam (
          .clk (clk),
          .addr(addr),
          .we  (en),
          .din (din),
          .qout(dout)
      );

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
