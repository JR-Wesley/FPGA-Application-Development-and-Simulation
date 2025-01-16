`ifndef __SPISLAVE_SV__
`define __SPISLAVE_SV__

`include "../../chapter4/counter/Counter.sv"
`include "../../chapter4/edge2en/Edge2En.sv"

module SpiSlave #(
    parameter int CHPA = 0
) (
  input  logic       clk,
  input  logic       rst,
  input  logic       ss_n,
  input  logic       sclk0,
  input  logic       mosi,
  output logic       miso,
  output logic       miso_tri,
  output logic       read,
  input  logic [7:0] tx_data,
  output logic       valid,
  output logic [7:0] rx_data,
  output logic       busy
);
  logic ss_n_reg;
  always_ff @(posedge clk) ss_n_reg <= ss_n;
  logic mosi_reg;
  always_ff @(posedge clk) mosi_reg <= mosi;

  // ss_n & sclk rising & falling
  logic sclk_r, sclk_f, ss_n_rising, ss_n_falling;
  wire sclk_rising = sclk_r & ~ss_n_reg;
  wire sclk_falling = sclk_f & ~ss_n_reg;
  Edge2En #(1)
      ssnEdgeDet (
        clk,
        ss_n,
        ss_n_rising,
        ss_n_falling,
      ),
      sclkEdgeDet (
        clk,
        sclk0,
        sclk_r,
        sclk_f,
      );

  // bit_cnt
  logic [11:0] bit_cnt;
  wire bit_cnt_en = ~ss_n_reg & ((CHPA == 0) ? sclk_rising : sclk_falling);
  Counter #(4096) bitCnt (
    clk,
    rst | ss_n_falling,
    bit_cnt_en,
    bit_cnt,
  );
  // busy driven
  always_ff @(posedge clk) begin
    if (rst) busy <= '0;
    else if (ss_n_falling) busy <= '1;
    else if (ss_n_rising) busy <= '0;
  end
  // tx_data & miso
  assign read = (CHPA == 0)?
                    ss_n_falling | (sclk_falling && bit_cnt[2:0] == 3'd0)
                  : sclk_rising && bit_cnt[2:0] == 3'd0;
  logic read_dly;
  always_ff @(posedge clk) read_dly <= read;
  wire out_shift = (CHPA == 0) ? sclk_falling : sclk_rising;
  logic [7:0] miso_shift_reg;
  always_ff @(posedge clk) begin
    if (rst) miso_shift_reg <= '0;
    else if (read_dly) miso_shift_reg <= tx_data;
    else if (out_shift & ~read) miso_shift_reg <= miso_shift_reg >> 1;
  end
  assign miso = miso_shift_reg[0];
  assign miso_tri = ss_n_reg;
  // mosi & rx_data
  wire in_shift = (CHPA == 0) ? sclk_rising : sclk_falling;
  wire out_valid = (CHPA == 0)? sclk_rising && bit_cnt[2:0] == 3'd7
                                 : sclk_falling && bit_cnt[2:0] == 3'd7;
  always_ff @(posedge clk) valid <= out_valid;
  logic [7:0] mosi_shift_reg;
  always_ff @(posedge clk) begin
    if (rst) mosi_shift_reg <= '0;
    else if (in_shift) mosi_shift_reg <= {mosi, mosi_shift_reg[7:1]};
  end
  always_ff @(posedge clk) begin
    if (rst) rx_data <= '0;
    else if (out_valid) rx_data <= {mosi, mosi_shift_reg[7:1]};
  end
endmodule

`endif
