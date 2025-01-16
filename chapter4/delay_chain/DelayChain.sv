`ifndef __DELAY_CHAIN_SV__
`define __DELAY_CHAIN_SV__

module DelayChain #(
    parameter int  DW   = 8,
    parameter int  LEN  = 4,
    parameter type dw_t = logic [DW - 1 : 0]
) (
  input  logic clk,
  input  logic rst_n,
  input  logic en,
  input  dw_t  in,
  output dw_t  out
);

  generate
    if (LEN == 0) begin : g_zero_delay
      assign out = in;

    end else if (LEN == 1) begin : g_one_delay
      dw_t dly;
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
