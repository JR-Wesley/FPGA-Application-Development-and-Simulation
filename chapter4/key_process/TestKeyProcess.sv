`timescale 1ms / 1us
`include "../../SimSrcGen.sv"
`include "./KeyProcess.sv"

module TestKeyProcess;
  initial #200 $finish;

  import SimSrcGen::GenClk;
  logic clk;
  initial GenClk(clk, 0.02, 0.1);
  // clock period 0.1ms

  task automatic KeyPress(ref logic key, input realtime t);
    for (int i = 0; i < 30; i++) begin
      #0.13ms key = '0;
      #0.12ms key = '1;
    end
    #t;
    key = '0;
  endtask

  logic key = '0, key_en;
  initial begin
    #10 KeyPress(.key(key), .t(50));
    #50 KeyPress(key, 50);
  end

  // sample every 100 * 0.1ms = 20ms
  KeyProcess #(
      .SMP_INTV(100),
      .KEY_NUM (1)
  ) theKeyProc (
    .*
  );

endmodule
