
module ShiftReg #(
    parameter int  DW   = 8,
    parameter type dw_t = logic [DW - 1 : 0]
) (
  input  logic clk,
  input  logic rst_n,
  input  logic shift,
  input  logic load,
  input  dw_t  d,
  input  logic serial_in,
  output dw_t  q
);

  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= '0;
    else if (load) q <= d;
    else if (shift) q <= {q[DW-2:0], serial_in};
  end

endmodule
