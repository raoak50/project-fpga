module debouncer #(
    parameter int COUNT_MAX = 2_500_000  // e.g., 25ms window at a 100MHz clock
) (
    input  logic clk,
    input  logic resetn,
    input  logic button_in,
    output logic button_out
);

  logic btn_sync_0;
  logic btn_sync_1;
  logic [31:0] counter;

  always_ff @(posedge clk) begin
    if (!resetn) begin
      btn_sync_0 <= 1'b1;
      btn_sync_1 <= 1'b1;
    end else begin
      btn_sync_0 <= button_in;
      btn_sync_1 <= btn_sync_0;
    end
  end

  always_ff @(posedge clk) begin
    if (!resetn) begin
      button_out <= 1'b1;
      counter    <= '0;
    end else begin
      if (btn_sync_1 != button_out) begin
        if (counter < COUNT_MAX - 1) begin
          counter <= counter + 1'b1;
        end else begin
          button_out <= btn_sync_1;
          counter    <= '0;
        end
      end else begin
        counter <= '0;
      end
    end
  end

endmodule
