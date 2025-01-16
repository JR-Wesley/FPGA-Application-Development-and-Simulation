`ifndef __UARTTX_SV__
`define __UARTTX_SV__

`include "../../chapter4/counter/Counter.sv"
`include "../../chapter4/edge2en/Falling2En.sv"

module UartTx #(
    parameter int BR_DIV = 868,  // 115200 @100MHz
    // parity: 0 - none, 1 - odd, 2 - even
    parameter int PARITY = 0
) (
  input  logic       clk,
  input  logic       rst,
  input  logic [7:0] din,
  input  logic       start,
  output logic       busy,
  output logic       txd
);

  localparam [3:0] BC_MAX = PARITY ? 4'd10 : 4'd9;
  logic br_en, bit_co;
  Counter #(BR_DIV) theBrCnt (
    clk,
    rst,
    start | busy
    ,,
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
    else if (start) busy <= 1'b1;
  end

  // shift_reg & parity
  logic [10:0] shift_reg;  // {stop, par?, din[7:0], start}
  always_ff @(posedge clk) begin
    if (rst) shift_reg <= '1;
    else if (start & ~busy) begin
      case (PARITY)
        1: shift_reg <= {1'b1, ^din, din, 1'b0};
        2: shift_reg <= {1'b1, ~^din, din, 1'b0};
        default: shift_reg <= {2'b11, din, 1'b0};
      endcase
    end else if (br_en) shift_reg <= shift_reg >> 1;
  end

  // txd output
  always_ff @(posedge clk) begin
    if (~busy) txd <= 1'b1;  // idle
    else txd <= shift_reg[0];  // data & parity
  end

endmodule

`endif
