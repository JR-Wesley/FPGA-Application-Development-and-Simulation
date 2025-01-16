`ifndef __UARTRX_SV__
`define __UARTRX_SV__

`include "../../chapter4/counter/Counter.sv"
`include "../../chapter4/edge2en/Falling2En.sv"

module UartRx #(
    parameter int BR_DIV = 868,  // 115200 @100MHz
    // parity: 0 - none, 1 - even, 2 - odd
    parameter int PARITY = 0
) (
  input  logic       clk,
  input  logic       rst,
  input  logic       rxd,
  output logic [7:0] dout,
  output logic       dout_valid,
  output logic       par_err,
  output logic       busy
);

  // input sync & falling edge detect.
  logic rxd_falling, rxd_reg;
  Falling2En #(2) theFallingDet (
    clk,
    rxd,
    rxd_falling,
    rxd_reg
  );

  // bitrate counter & bit counter
  localparam [3:0] BC_MAX = PARITY ? 4'd9 : 4'd8;

  logic br_en, bit_co;
  logic [$clog2(BR_DIV) - 1 : 0] br_cnt;
  //logic [3:0] bit_cnt;
  Counter #(BR_DIV) theBrCnt (
    clk,
    rst | (rxd_falling & ~busy),
    busy,
    br_cnt,
    br_en
  );
  Counter #(BC_MAX + 1) theBitCnt (
    clk,
    rst,
    br_en
    ,  /*bit_cnt*/,
    bit_co
  );

  // busy driven
  always_ff @(posedge clk) begin
    if (rst) busy <= 1'b0;
    else if (bit_co) busy <= 1'b0;
    else if (rxd_falling) busy <= 1'b1;
  end

  // data sampling
  logic [8:0] shift_reg;
  always_ff @(posedge clk) begin
    if (rst) shift_reg <= '0;
    // sampling at middle of data bit
    else if (br_cnt == BR_DIV / 2) shift_reg <= {rxd_reg, shift_reg[8:1]};
  end

  // output
  always_ff @(posedge clk) begin
    if (rst) begin
      dout <= 8'd0;
      dout_valid <= 1'b0;
      par_err <= 1'b0;
    end else if (bit_co) begin
      dout_valid <= 1'b1;
      case (PARITY)
        1: {par_err, dout} <= {^shift_reg, shift_reg[7:0]};
        2: {par_err, dout} <= {~^shift_reg, shift_reg[7:0]};
        default: {par_err, dout} <= {1'b0, shift_reg[8:1]};
      endcase
    end else dout_valid <= 1'b0;
  end

endmodule

`endif
