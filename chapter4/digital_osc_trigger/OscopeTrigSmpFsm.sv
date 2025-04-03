
module OscopeTrigSmpFsm #(
    parameter DLEN = 1000
) (
  input  wire                       clk,
  rst,
  en,
  start,
  trigger,
  input  wire  [$clog2(DLEN)-1 : 0] hpos,
  input  wire  [            26 : 0] to,
  output logic                      fifo_write,
  busy,
  output logic                      trigger_flag
);
  localparam S_IDLE = 5'h1;
  localparam S_PRE = 5'h2;
  localparam S_WAIT = 5'h4;
  localparam S_TRIG = 5'h8;
  localparam S_TOUT = 5'h10;
  logic [$clog2(DLEN)-1 : 0] hpos_reg;
  logic [26 : 0] to_reg;
  logic [$clog2(DLEN)-1 : 0] data_cnt;
  always_ff @(posedge clk) if (start) hpos_reg <= hpos;
  always_ff @(posedge clk) if (start) to_reg <= to;
  logic [4:0] state, state_nxt;
  // state driven
  always_ff @(posedge clk) begin
    if (rst) state <= S_IDLE;
    else state <= state_nxt;
  end
  // state transfer
  always_comb begin
    state_nxt = state;
    case (state)
      S_IDLE:  if (start) state_nxt = S_PRE;
      S_PRE:   if (en && data_cnt == hpos_reg) state_nxt = S_WAIT;
      S_WAIT:
      if (en && data_cnt == to) begin
        if (hpos_reg + to_reg < DLEN) state_nxt = S_TOUT;
        else state_nxt = S_IDLE;
      end else if (trigger) state_nxt = S_TRIG;
      S_TRIG:  if (en && data_cnt == DLEN - hpos) state_nxt = S_IDLE;
      S_TOUT:  if (en && data_cnt == DLEN - hpos - to) state_nxt = S_IDLE;
      default: state_nxt = state;
    endcase
  end
  // status outputs
  assign fifo_write = (state == S_PRE || state == S_WAIT || state == S_TRIG || state == S_TOUT);
  assign busy = fifo_write;
  wire data_cnting = fifo_write;
  // event outputs
  wire data_cnt_clr = ((state == S_IDLE && state_nxt == S_PRE) ||
						(state == S_PRE && state_nxt == S_WAIT) ||
						(state == S_WAIT && state_nxt == S_TRIG) ||
						(state == S_WAIT && state_nxt == S_TOUT));
  wire trigger_flag_clr = (state == S_IDLE && state_nxt == S_PRE);
  wire trigger_flag_set = (state == S_WAIT && state_nxt == S_TRIG);
  // data_cnt driven
  always_ff @(posedge clk) begin
    if (rst) data_cnt <= '0;
    else if (data_cnt_clr) data_cnt <= '0;
    else if (data_cnting & en) data_cnt <= data_cnt + 1'b1;
  end
  // trigger flag driven
  always_ff @(posedge clk) begin
    if (rst) trigger_flag <= '0;
    else if (trigger_flag_clr) trigger_flag <= '0;
    else if (trigger_flag_set) trigger_flag <= '1;
  end
endmodule
