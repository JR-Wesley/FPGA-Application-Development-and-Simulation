`ifndef __CNT_SEC_MIN_HR_SV__
`define __CNT_SEC_MIN_HR_SV__

`include "Counter.sv"

module CntSecMinHr (
    input  logic       clk,
    input  logic       rst_n,
    output logic [5:0] sec,
    output logic [5:0] min,
    output logic [4:0] hr
);

  logic en1sec, en1min, en1hr;
  Counter #(10) cnt1sec (
      .*,
      .en (1'b1),
      .cnt(),
      .co (en1sec)
  );
  Counter #(60) cnt60sec (
      .*,
      .en (en1sec),
      .cnt(sec),
      .co (en1min)
  );
  Counter #(60) cnt60min (
      .*,
      .en (en1min),
      .cnt(min),
      .co (en1hr)
  );
  Counter #(24) cnt24hr (
      .*,
      .en (en1hr),
      .cnt(hr),
      .co ()
  );

endmodule

`endif
