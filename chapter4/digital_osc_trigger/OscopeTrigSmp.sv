
module OscopeTrigSmp (
  input  wire                clk,
  rst,
  input  wire signed  [ 7:0] din,
  input  wire                en,
  start,
  input  wire signed  [ 7:0] level,
  input  wire         [ 9:0] hpos,
  input  wire         [26:0] to,
  output logic signed [ 7:0] dout,
  input  wire                read,
  output logic               busy,
  trig_flag
);
  localparam DLEN = 1000;
  logic signed [7:0] d_reg[2];
  always_ff @(posedge clk) begin
    if (rst) d_reg <= '{2{'0}};
    else if (en) d_reg <= '{din, d_reg[0]};
  end
  wire trig = en & (d_reg[1] < level && d_reg[0] >= level);
  logic write;
  logic [9:0] fifo_dc;
  ScFifo2 #(8, 10) theFifo (
    clk,
    rst,
    d_reg[1],
    write & en,
    dout,
    fifo_dc > DLEN || read
    ,,,
    fifo_dc
    ,,
  );
  OscopeTrigSmpFsm #(DLEN) theFsm (
    clk,
    rst,
    en,
    start,
    trig,
    hpos,
    to,
    write,
    busy,
    trig_flag
  );
endmodule
