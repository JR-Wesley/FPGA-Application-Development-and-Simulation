

module Pwm2 (
  input  logic          clk,
  input  logic          rst_n,
  input  logic [31 : 0] max,
  input  logic [31 : 0] data,
  output logic          pwm,
  output logic          co
);

  logic [31 : 0] cnt = '0;
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) cnt <= '0;
    else if (cnt < max) cnt <= cnt + 1'd1;
    else cnt <= '0;
  end

  always_ff @(posedge clk, negedge rst_n) pwm <= (data > cnt);
  assign co = cnt == max;

endmodule
