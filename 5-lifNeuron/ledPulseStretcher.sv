module ledPulseStretcher #(
    parameter int COUNT_MAX = 10_000_000
) (
    input  logic clk,
    input  logic resetn,
    input  logic spike,
    output logic led
);

  logic [31:0] counter;

  always_ff @(posedge clk) begin
    if (!resetn) begin
      counter <= '0;
      led <= 1'b1;
    end else begin
      if (spike) begin
        counter <= COUNT_MAX - 1;
        led <= 1'b0;
      end else if (counter != 0) begin
        counter <= counter - 1'b1;
        led <= 1'b0;
      end else begin
        led <= 1'b1;
      end
    end
  end

endmodule
