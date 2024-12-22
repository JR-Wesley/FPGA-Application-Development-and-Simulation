`ifndef _R2SDF_SV__
`define _R2SDF_SV__

`include "../../chapter4/delay_chain/DelayChain.sv"
`include "../../chapter4/delay_chain_mem/DelayChainMem.sv"
`include "./R2SdfDefinesPkg.sv"
`include "./R2SdfCoefRom.sv"
`include "./Bf2.sv"

module R2Sdf
  import R2SdfDefinesPkg::*;
#(
    parameter int STG = 4
) (
  input  wire  clk,
  input  wire  rst,
  input  wire  en,
  input  wire  scale,
  input  wire  invexp,
  input  Cplx  in,
  input  wire  in_sync,
  output Cplx  out,
  output logic out_sync
);

  Cplx bf2_x0[STG], bf2_x1[STG], bf2_z0[STG], bf2_z1[STG];
  assign bf2_x1[STG-1] = in;
  always_ff @(posedge clk) begin
    if (rst) out <= '{'0, '0};
    else if (en) out <= bf2_z0[0];
  end

  logic [STG - 1 : 0] ccnt;
  always_ff @(posedge clk) begin
    if (rst) ccnt <= 'b0;
    else if (en) begin
      if (in_sync) ccnt <= 'b0;
      else ccnt <= ccnt + 1'b1;
    end
  end

  always_ff @(posedge clk) begin
    if (rst) out_sync <= '0;
    else if (en) out_sync <= ccnt == STG'(STG * 2 - 4);
  end

  generate
    for (genvar s = STG - 1; s >= 0; s--) begin : g_bfStg
      logic s_dly;
      DelayChain #(1, 2 * (STG - s - 1)) dlyCnt (
          clk,
          rst,
          en,
          ccnt[s],
          s_dly
      );
      Bf2 theBf2 (
          .x0   (bf2_x0[s]),
          .x1   (bf2_x1[s]),
          .z0   (bf2_z0[s]),
          .z1   (bf2_z1[s]),
          .s    (s_dly),
          .scale(scale)
      );
      DelayChainMem #(
          .DW(DW),
          .LEN(2 ** s)
      ) dcBf2Real (
          clk,
          rst,
          en,
          bf2_z1[s].re,
          bf2_x0[s].re
      );
      DelayChainMem #(
          .DW(DW),
          .LEN(2 ** s)
      ) dcBf2Imag (
          clk,
          rst,
          en,
          bf2_z1[s].im,
          bf2_x0[s].im
      );
    end
  endgenerate

  generate
    for (genvar s = STG - 2; s >= 0; s--) begin : g_mulStg
      logic [s+1:0] cnt_dly;
      DelayChain #(s + 2, 2 * (STG - s - 2)) dlyCnt (
          clk,
          rst,
          en,
          ccnt[s+1:0],
          cnt_dly
      );
      Cplx mulin, w, mulout;
      logic [s : 0] waddr;
      always_ff @(posedge clk) begin
        if (rst) mulin <= '{'0, '0};
        else if (en) mulin <= bf2_z0[s+1];
      end
      assign waddr = cnt_dly[s+1] ? '0 : cnt_dly[s : 0];
      R2SdfCoefRom #(DW, s + 1, "Real") wReal (
          clk,
          waddr,
          w.re
      );
      R2SdfCoefRom #(DW, s + 1, "Imag") wImag (
          clk,
          waddr,
          w.im
      );
      always_comb mulout = cmul(mulin, '{w.re, invexp ? -w.im : w.im});
      always_ff @(posedge clk) begin
        if (rst) bf2_x1[s] <= '{'0, '0};
        else if (en) bf2_x1[s] <= mulout;
      end
    end
  endgenerate

endmodule

`endif
