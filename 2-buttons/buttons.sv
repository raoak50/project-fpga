module buttons(
    input logic button,
    input logic clk,
    output logic led
);

logic state;
logic previous_button;

always_ff @( posedge clk ) begin
    if (!previous_button && button)
        state <= !state;
    previous_button <= button;
end

assign led = state;

endmodule
