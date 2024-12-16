`timescale 1ns / 100ps
`include "./RecfgDelayChain.sv"

`default_nettype none

module TestRecfgDelayChain;
  initial begin
    $dumpfile("TestRecfgDelayChain.vcd");
    $dumpvars(0, TestRecfgDelayChain);
  end

  logic clk = 1'b0;
  logic rst_n = 1'b0;
  initial forever #5 clk = ~clk;
  initial #35 rst_n = 1'b1;
  initial #5000 $finish;

  localparam integer DW = 8;
  localparam integer MAXLEN = 16;
  logic [DW - 1 : 0] a, y;
  logic en = 0;
  int seed_en = 321384;
  int seed_len = 8734;
  int en_cnt = 0;
  logic [$clog2(MAXLEN+1) - 1 : 0] len = '0;

  initial begin
    #20;
    @(posedge clk);
    forever begin
      repeat ($dist_poisson(seed_en, 2)) @(posedge clk);
      @(posedge clk) en = 1'b1;
      // @(posedge clk) en <= ~en;
    end
  end

  initial begin
    #20;
    @(posedge clk);
    forever begin
      repeat ($dist_poisson(seed_len, 64)) @(posedge clk);
      @(posedge clk) len = $clog2(MAXLEN + 1)'($urandom());
    end
  end

  always @(posedge clk) begin
    if (en) begin
      en_cnt <= en_cnt + 1'b1;
    end
  end
  always @(posedge clk) begin
    if (en) begin
      a <= DW'($urandom());
    end
  end

  RecfgDelayChain #(
      .DW(DW),
      .MAX_LEN(16),
      .MIN_LEN(0)
  ) dc (
      .clk   (clk),
      .rst_n (rst_n),
      .en    (en),
      .length(len),
      .din   (a),
      .dout  (y)
  );

endmodule

