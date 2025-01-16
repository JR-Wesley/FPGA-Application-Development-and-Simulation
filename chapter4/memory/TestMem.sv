`timescale 1ns / 100ps
`include "./SpRamRf.sv"

module TestMem;
  initial $dumpvars(0, TestMem);
  initial #400 $finish;

  logic clk = 1'b0;
  initial forever #5 clk = ~clk;

  logic [7 : 0] a = 0, d = 0;
  logic [7 : 0] q;
  logic we = 0;

  initial begin
    #10{we, a, d} = {1'b1, 8'h01, 8'h10};
    #10{we, a, d} = {1'b1, 8'h03, 8'h30};
    #10{we, a, d} = {1'b1, 8'h06, 8'h60};
    #10{we, a, d} = {1'b1, 8'h0a, 8'ha0};
    #10{we, a, d} = {1'b1, 8'h0f, 8'hf0};
    #10{we, a, d} = {1'b0, 8'h00, 8'h00};
    forever #10 a++;
    // During simulation, the uninitialized addresses' data is 'X'.
    // For FPGA, the registers are usually set to '0'.
    // And some FPGA tool support declaration initial assignment.
  end

  SpRamRf theMem (
    .clk (clk),
    .addr(a),
    .we  (we),
    .din (d),
    .qout(q)
  );

endmodule

