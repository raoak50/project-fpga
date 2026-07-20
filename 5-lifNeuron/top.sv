module top (
    input logic clk,
    input logic resetn,
    input logic button,
    output logic [3:0] led
);

  logic [3:0] spikes;
  logic [3:0] neuronSpikes;

  logic previous_button;
  logic button_pressed;
  logic button_db;

  debouncer #(
      .COUNT_MAX(2_500_000)
  ) debounce (
      .clk(clk),
      .resetn(resetn),
      .button_in(button),
      .button_out(button_db)
  );

  always_ff @(posedge clk) begin
    if (!resetn) begin
      previous_button <= 1'b1;
      button_pressed  <= 1'b0;
    end else begin
      previous_button <= button_db;
      button_pressed  <= previous_button && !button_db;
    end
  end

  assign spikes[0] = button_pressed;
  assign spikes[1] = 1'b0;
  assign spikes[2] = 1'b0;
  assign spikes[3] = 1'b0;

  lifNetwork #(
      .NUM_NEURONS(4),
      .DATA_WIDTH (6)
  ) network (
      .clk(clk),
      .resetn(resetn),
      .inSpike(spikes),
      .outSpike(neuronSpikes)
  );

  ledPulseStretcher #(
      .COUNT_MAX(10_000_000)
  ) led0 (
      .clk(clk),
      .resetn(resetn),
      .spike(neuronSpikes[0]),
      .led(led[0])
  );

  ledPulseStretcher #(
      .COUNT_MAX(10_000_000)
  ) led1 (
      .clk(clk),
      .resetn(resetn),
      .spike(neuronSpikes[1]),
      .led(led[1])
  );

  ledPulseStretcher #(
      .COUNT_MAX(10_000_000)
  ) led2 (
      .clk(clk),
      .resetn(resetn),
      .spike(neuronSpikes[2]),
      .led(led[2])
  );

  ledPulseStretcher #(
      .COUNT_MAX(10_000_000)
  ) led3 (
      .clk(clk),
      .resetn(resetn),
      .spike(neuronSpikes[3]),
      .led(led[3])
  );

endmodule
