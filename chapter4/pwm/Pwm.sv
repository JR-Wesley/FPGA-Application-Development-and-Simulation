
module Pwm #(
    parameter int  M    = 256,
    parameter type dw_t = logic [$clog2(M) - 1 : 0]
) (
  input  logic clk,
  input  logic rst_n,
  input  dw_t  data,   // data range [0, M-1]
  output logic pwm,
  output logic co
);
  dw_t cnt, cnt_next;
  always_comb begin
    cnt_next = '0;
    if (cnt < M - 1) cnt_next = cnt + 1'b1;
  end
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) cnt <= '0;
    else cnt <= cnt_next;
  end

  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) pwm <= '0;
    else pwm <= (data > cnt);
  end

  assign co = cnt == M - 1;

endmodule
