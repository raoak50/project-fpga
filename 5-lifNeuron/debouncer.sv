module debouncer #(
    parameter int COUNT_MAX = 2_500_000
) (
    input  logic clk,
    input  logic resetn,
    input  logic button_in,
    output logic button_out
);

  logic button_sync;
  logic [31:0] counter;

  always_ff @(posedge clk) begin
    if (!resetn) begin
      button_sync <= 1'b1;
      button_out <= 1'b1;
      counter <= '0;
    end else begin
      if (button_in != button_sync) begin
        button_sync <= button_in;
        counter <= '0;
      end else if (counter < COUNT_MAX - 1) begin
        counter <= counter + 1'b1;
      end else begin
        button_out <= button_sync;
      end
    end
  end
endmodule
