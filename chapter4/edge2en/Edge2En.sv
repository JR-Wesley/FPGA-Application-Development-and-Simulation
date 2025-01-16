`ifndef __EDEG2EN_SV__
`define __EDEG2EN_SV__

module Edge2En #(
    parameter int SYNC_STG = 1
) (
  input  logic clk,
  input  logic in,
  output logic rising,
  output logic falling,
  output logic out
);

  logic [SYNC_STG : 0] dly;
  always_ff @(posedge clk) begin
    dly <= {dly[SYNC_STG-1 : 0], in};
  end

  assign rising = (SYNC_STG ? dly[SYNC_STG-:2] : {dly, in}) == 2'b01;
  assign falling = (SYNC_STG ? dly[SYNC_STG-:2] : {dly, in}) == 2'b10;
  assign out = dly[SYNC_STG];

endmodule

`endif
