`ifndef _SCFIFOSA_SV__
`define _SCFIFOSA_SV__

`include "../memory/SdpRamRa.sv"

module ScFifoSA #(
    // output show-ahead(altera's term) or FWFT(xilinx's term)
    parameter int  DW   = 8,
    parameter int  AW   = 10,
    parameter type dw_t = logic [DW - 1 : 0],
    parameter type aw_t = logic [AW - 1 : 0]
) (
  input  logic clk,
  input  logic rst_n,
  input  dw_t  din,
  input  logic write,
  output dw_t  dout,
  input  logic read,
  output aw_t  wr_cnt,
  output aw_t  rd_cnt,
  output aw_t  data_cnt,
  output logic full,
  output logic empty
);

  localparam int CAPACITY = 2 ** AW - 1;

  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) wr_cnt <= '0;
    else if (write) wr_cnt <= wr_cnt + 1'b1;
  end
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) rd_cnt <= '0;
    else if (read) rd_cnt <= rd_cnt + 1'b1;
  end

  assign data_cnt = wr_cnt - rd_cnt;
  assign full = data_cnt == CAPACITY;
  assign empty = data_cnt == 0;

  SdpRamRa #(
      .DW   (DW),
      .WORDS(2 ** AW)
  ) theRam (
    .clk   (clk),
    .addr_a(wr_cnt),
    .wr_a  (write),
    .din_a (din),
    .addr_b(rd_cnt),
    .qout_b(dout)
  );

endmodule

`endif
