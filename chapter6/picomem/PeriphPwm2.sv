`include "mm_intercon.sv"

module PeriphPwm2 (
         PicoMmIf.slave s,
  output logic          pwm,
  output logic          co
);
  wire addr = s.addr >> 2;
  logic [31 : 0] period, duty;
  always_ff @(posedge s.clk) begin
    if (s.rst) begin
      period <= '0;
      duty <= '0;
    end else if (s.write) begin
      case (addr)
        0: period <= s.wrdata;
        1: duty <= s.wrdata;
      endcase
    end
  end
  always_ff @(posedge s.clk) s.rddata <= addr == 0 ? period : duty;
  Pwm2 thePwm (
    s.clk,
    s.rst,
    period,
    duty,
    pwm,
    co
  );
endmodule

