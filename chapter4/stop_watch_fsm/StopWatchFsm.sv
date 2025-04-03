
module StopWatchFsm (
  input  logic clk,
  input  logic rst_n,
  input  logic k0,
  input  logic k1,
  output logic timming,
  output logic freezing,
  output logic reset,
  output logic update
);

  typedef enum logic [3 : 0] {
    S_STOP = 4'h1,
    S_RUN = 4'h2,
    S_PAUSE = 4'h4,
    S_FREEZE = 4'h8
  } state_t;
  state_t state, state_nxt;

  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) state <= S_STOP;
    else state <= state_nxt;
  end

  always_comb begin
    state_nxt = state;
    case (state)
      S_STOP: if (k0) state_nxt = S_RUN;
      S_RUN:
      if (k0) state_nxt = S_PAUSE;
      else if (k1) state_nxt = S_FREEZE;
      S_PAUSE:
      if (k0) state_nxt = S_RUN;
      else if (k1) state_nxt = S_STOP;
      S_FREEZE:
      if (k0) state_nxt = S_RUN;
      else if (k1) state_nxt = S_FREEZE;
      default: state_nxt = state;
    endcase
  end

  always_ff @(posedge clk, negedge rst_n) timming <= (state == S_RUN) || (state == S_FREEZE);
  always_ff @(posedge clk, negedge rst_n) freezing <= (state == S_FREEZE);
  always_ff @(posedge clk, negedge rst_n) reset <= k1 && (state == S_PAUSE);
  always_ff @(posedge clk, negedge rst_n) update <= k1 && (state == S_FREEZE);

endmodule

