`ifndef __EDGE2EN_SV__
`define __EDGE2EN_SV__

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
  generate
    if (SYNC_STG == 0) begin : g_reg
      always_ff @(posedge clk) begin
        dly <= in;
      end
      assign falling = {dly, in} == 2'b10;
      assign rising = {dly, in} == 2'b01;

    end else begin : g_chain
      always_ff @(posedge clk) begin
        dly <= {dly[SYNC_STG-1 : 0], in};
      end
      assign falling = dly[SYNC_STG-:2] == 2'b10;
      assign rising = dly[SYNC_STG-:2] == 2'b01;

    end
  endgenerate

  assign out = dly[SYNC_STG];

endmodule

`endif
