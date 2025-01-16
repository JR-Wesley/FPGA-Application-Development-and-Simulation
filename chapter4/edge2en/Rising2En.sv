`ifndef __RISING2EN_SV__
`define __RISING2EN_SV__

module Rising2En #(
    parameter int SYNC_STG = 1
) (
  input  logic clk,
  input  logic in,
  output logic en,
  output logic out
);

  logic [SYNC_STG : 0] dly;
  generate
    if (SYNC_STG == 0) begin : g_reg
      always_ff @(posedge clk) begin
        dly <= in;
      end
      assign en = {dly, in} == 2'b01;

    end else begin : g_chain
      always_ff @(posedge clk) begin
        dly <= {dly[SYNC_STG-1 : 0], in};
      end
      assign en = dly[SYNC_STG-:2] == 2'b01;

    end
  endgenerate

  // assign en = (SYNC_STG ? dly[SYNC_STG-:2] : {dly, in}) == 2'b01;
  assign out = dly[SYNC_STG];

endmodule

`endif
