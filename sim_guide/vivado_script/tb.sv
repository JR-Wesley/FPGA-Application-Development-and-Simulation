`include "./adder.sv"

module tb;
  logic [31 : 0] a, b, sum;
  adder DUT (.*);

  initial begin
    a = 1;
    b = 2;
    #1;
    assert (sum == a + b)
    else begin
      $fatal(1, "3 != 1 + 2");
    end
    $display("TB passed.");
  end

endmodule
