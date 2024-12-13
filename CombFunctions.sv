
`ifndef _COMBFUNCTIONS_SV__
`define _COMBFUNCTIONS_SV__

package CombFunctions;
  `define DEF_PRIO_ENC(fname, ow) \
  function automatic logic [ow - 1 : 0] fname( \
    input logic [2**ow - 1 : 0] in \
    ); \
    fname = '0; \
    for(integer i = 2**ow - 1; i >= 0; i--) begin \
      if(in[i]) fname = ow'(i); \
      end \
  endfunction
endpackage

`endif
