
module PeriphPwm (
  input  logic          clk,
  input  logic          rst_n,
  input  logic          addr,
  input  logic [31 : 0] wrdata,
  input  logic          write,
  output logic [31 : 0] rddata,
  output logic          pwm,
  output logic          co
);

  logic [31 : 0] period, duty;
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      period <= '0;
      duty <= '0;
    end else if (write) begin
      case (addr)
        0: period <= wrdata;
        1: duty <= wrdata;
        default: begin
          period <= period;
          duty <= duty;
        end
      endcase
    end
  end

  assign rddata = (addr == 0) ? period : duty;
  Pwm2 thePwm (
    .clk  (clk),
    .rst_n(rst_n),
    .max  (period),
    .data (duty),
    .pwm  (pwm),
    .co   (co)
  );

endmodule
