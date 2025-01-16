`ifndef _DCFIFO_SV__
`define _DCFIFO_SV__

`include "../memory/SdcRam.sv"
`include "../cross_cd_cnt_state/CrossClkCnt.sv"

module DcFifo #(
    parameter int  DW   = 8,
    parameter int  AW   = 10,
    parameter type dw_t = logic [DW - 1 : 0],
    parameter type aw_t = logic [AW - 1 : 0]
) (
  // ---- write domain ----
  input  logic w_clk,
  input  logic w_rst,
  input  dw_t  din,
  input  logic write,
  output aw_t  w_wr_cnt,
  output aw_t  w_rd_cnt,
  output aw_t  w_data_cnt,
  output logic w_full,
  output logic w_empty,
  // ---- read domain ----
  input  logic r_clk,
  input  logic r_rst,
  output dw_t  dout,
  input  logic read,
  output aw_t  r_wr_cnt,
  output aw_t  r_rd_cnt,
  output aw_t  r_data_cnt,
  output logic r_full,
  output logic r_empty
);

  localparam int CAPACITY = 2 ** AW - 1;
  dw_t qout_b, qout_b_reg = '0;

  // ---- write counter and read counter ----
  CrossClkCnt #(.W(AW))
      theCcdCntWr (  // write counter on write domain
        .clk_a(w_clk),
        .rst_a(w_rst),
        .clk_b(r_clk),
        .rst_b(r_rst),
        .inc  (write),
        .cnt_a(w_wr_cnt),  // the write counter
        .cnt_b(r_wr_cnt)   // write counter synced to read domain
      ),
      theCcdCntRd (  // read counter on read domain
        .clk_a(r_clk),
        .rst_a(r_rst),
        .clk_b(w_clk),
        .rst_b(w_rst),
        .inc  (read),
        .cnt_a(r_rd_cnt),  // the read counter
        .cnt_b(w_rd_cnt)   // read counter synced to write domain
      );

  // ---- the simple dual clock ram ----
  SdcRam #(
      .DW   (DW),
      .WORDS(2 ** AW)
  ) theRam (
    .clk_a (w_clk),
    .addr_a(w_wr_cnt),
    .wr_a  (write),
    .din_a (din),
    .clk_b (r_clk),
    .addr_b(r_rd_cnt),
    .qout_b(qout_b)
  );

  // ---- refine output behavior ----
  logic rd_dly;
  always_ff @(posedge r_clk) begin
    if (r_rst) rd_dly <= 1'b0;
    else rd_dly <= read;
  end
  always_ff @(posedge r_clk) begin
    if (r_rst) qout_b_reg <= '0;
    else if (rd_dly) qout_b_reg <= qout_b;
  end
  assign dout = (rd_dly) ? qout_b : qout_b_reg;

  // ---- flags ----
  assign w_data_cnt = w_wr_cnt - w_rd_cnt;
  assign w_full = w_data_cnt == CAPACITY;
  assign w_empty = w_data_cnt == 0;
  assign r_data_cnt = r_wr_cnt - r_rd_cnt;
  assign r_full = r_data_cnt == CAPACITY;
  assign r_empty = r_data_cnt == 0;

endmodule

`endif
