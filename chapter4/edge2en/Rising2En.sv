
module Rising2En #(
    parameter SYNC_STG = 1
) (
  input  wire  clk,
  in,
  output logic en,
  out
);
  logic [SYNC_STG : 0] dly;
  always_ff @(posedge clk) begin
    dly <= {dly[SYNC_STG-1 : 0], in};
  end
  assign en = (SYNC_STG ? dly[SYNC_STG-:2] : {dly, in}) == 2'b01;
  assign out = dly[SYNC_STG];
endmodule
