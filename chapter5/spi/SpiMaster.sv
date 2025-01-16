`ifndef __SPISLAVE_SV__
`define __SPISLAVE_SV__

module SpiMaster #(
    parameter HBR_DIV = 5,  //10Msps@100MHz
    parameter CHPA    = 0
) (
  input  wire         clk,
  rst,
  start,
  input  wire  [23:0] ss_mask,
  input  wire  [ 7:0] trans_len,
  output logic        read,
  input  wire  [ 7:0] tx_data,
  output logic        valid,
  output logic [ 7:0] rx_data,
  output logic        busy,
  output logic        sclk0,
  sclk1,
  mosi,
  mosi_tri,
  input  wire         miso,
  output logic [23:0] ss_n
);
  // hbr_cnt & hbit_cnt
  logic hbr_co, hbit_co;
  logic [12:0] hbit_cnt;  // 2 + 16 * 256 = 4098 -> 13bit
  logic [12:0] hbit_cnt_max;
  always_ff @(posedge clk) begin
    if (rst) hbit_cnt_max <= '0;
    else if (start) hbit_cnt_max <= 13'd1 + ((13'(trans_len) + 13'd1) << 4);
  end
  Counter #(HBR_DIV) hbrCnt (
    clk,
    rst,
    busy
    ,,
    hbr_co
  );
  CounterMax #(13) hbitCnt (
    clk,
    rst,
    hbr_co,
    hbit_cnt_max,
    hbit_cnt,
    hbit_co
  );
  // busy driven
  always_ff @(posedge clk) begin
    if (rst) busy <= '0;
    else if (start) busy <= '1;
    else if (hbit_co) busy <= '0;
  end
  // tx_data & mosi
  assign read = (CHPA == 0)?
                      start | (hbit_cnt[3:0] == 4'd15
                      & hbr_co & hbit_cnt < hbit_cnt_max - 13'd16)
                    : hbit_cnt[3:0] == 4'd0 & hbr_co
                      & hbit_cnt < hbit_cnt_max - 16;
  logic read_dly;
  always_ff @(posedge clk) read_dly <= read;
  wire out_shift = (CHPA == 0) ? hbit_cnt[0] == 1'd1 & hbr_co : hbit_cnt[0] == 1'd0 & hbr_co;
  logic [7:0] mosi_shift_reg;
  always_ff @(posedge clk) begin
    if (rst) mosi_shift_reg <= '0;
    else if (read_dly) mosi_shift_reg <= tx_data;
    else if (out_shift) mosi_shift_reg <= mosi_shift_reg >> 1;
  end
  assign mosi_tri = ~busy;
  always_ff @(posedge clk) mosi <= mosi_shift_reg[0];
  // miso & rx_data
  wire in_shift = (CHPA == 0) ? hbit_cnt[0] == 1'd1 & hbr_co : hbit_cnt[0] == 1'd0 & hbr_co;
  wire out_valid = (CHPA == 0)? hbit_cnt[3:0] == 4'd15 & hbr_co
                  : hbit_cnt[3:0] == 4'd0 & hbr_co & hbit_cnt > 0;
  always_ff @(posedge clk) valid <= out_valid;
  logic [7:0] miso_shift_reg;
  always_ff @(posedge clk) begin
    if (rst) miso_shift_reg <= '0;
    else if (in_shift) miso_shift_reg <= {miso, miso_shift_reg[7:1]};
  end
  always_ff @(posedge clk) begin
    if (rst) rx_data <= '0;
    else if (out_valid) rx_data <= {miso, miso_shift_reg[7:1]};
  end
  // sclk & ss
  logic [23:0] ss_mask_reg;
  always_ff @(posedge clk) begin
    if (rst) ss_mask_reg <= '0;
    else if (start) ss_mask_reg <= ss_mask;
  end
  always_ff @(posedge clk) begin
    if (rst) begin
      sclk0 <= '0;
      sclk1 <= '1;
    end else if (hbit_cnt < hbit_cnt_max) begin
      sclk0 <= hbit_cnt[0];
      sclk1 <= ~hbit_cnt[0];
    end
  end
  always_ff @(posedge clk) begin
    if (rst) ss_n <= '1;
    else if (busy && hbit_cnt < hbit_cnt_max) ss_n <= ~ss_mask_reg;
    else ss_n <= '1;
  end
endmodule

`endif
