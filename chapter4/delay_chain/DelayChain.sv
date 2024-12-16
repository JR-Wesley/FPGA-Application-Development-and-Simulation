`ifndef __DELAY_CHAIN_SV__
`define __DELAY_CHAIN_SV__

module DelayChain #(
    parameter integer DW  = 8,
    parameter integer LEN = 4
) (
  input  wire               clk,
  input  wire               rst_n,
  input  wire               en,
  input  wire  [DW - 1 : 0] in,
  output logic [DW - 1 : 0] out
);

  generate
    if (LEN == 0) begin : g_zero_delay
      assign out = in;

    end else if (LEN == 1) begin : g_one_delay
      logic [DW - 1 : 0] dly;
      always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) dly <= '0;
        else if (en) dly <= in;
      end
      assign out = dly;

    end else begin : g_delay
      logic [LEN - 1 : 0][DW - 1 : 0] dly;
      always_ff @(posedge clk, negedge rst_n) begin
        // if (!rst_n) dly <= '{LEN{'0}};
        // assign to a packed array
        if (!rst_n) dly <= '0;
        else if (en) dly[0+:LEN] <= {dly[0+:LEN-1], in};
      end
      assign out = dly[LEN-1];

    end
  endgenerate

endmodule

`endif
