`ifndef __CROSS_CLK_CNT_SV__
`define __CROSS_CLK_CNT_SV__

module CrossClkCnt #(
    parameter int  DW    = 8,
    parameter type cnt_w = logic [DW - 1 : 0]
) (
  input  logic clk_a,
  input  logic clk_b,
  input  logic rst_n_a,
  input  logic rst_n_b,
  input  logic inc,
  output cnt_w cnt_a,
  output cnt_w cnt_b
);

  // === clk_a domain ===
  cnt_w bin_next;
  cnt_w gray, gray_next;
  always_comb begin : bin2gray
    bin_next = cnt_a + inc;
    gray_next = bin_next ^ (bin_next >> 1);
  end

  always_ff @(posedge clk_a, negedge rst_n_b) begin
    if (!rst_n_a) begin
      cnt_a <= '0;
      gray <= '0;
    end else begin
      cnt_a <= bin_next;
      gray <= gray_next;
    end
  end

  // === clk_b domain ===
  cnt_w gray_sync[2];
  always_ff @(posedge clk_b, negedge rst_n_b) begin
    if (!rst_n_b) begin
      gray_sync <= {DW'(0), DW'(0)};
    end else begin
      gray_sync <= {gray_sync[0], gray};
    end
  end
  always_comb begin : gray2bin
    for (int i = 0; i < DW; i++) cnt_b[i] = ^(gray_sync[1] >> i);
  end

endmodule

`endif
