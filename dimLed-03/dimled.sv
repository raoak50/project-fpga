module dimled (
    input logic clk,
    input logic buttonBright,
    input logic buttonDim,
    output logic led
);

reg [7:0] counter;

reg [7:0] brightness;

reg previousButtonBright;
reg previousButtonDim;

reg state;

initial begin
    counter = 8'b0;
    brightness = 8'b0;
    previousButtonBright = 1'b0;
    previousButtonDim = 1'b0;
    state = 1'b0;
end

always_ff @(posedge clk) begin
    if ((previousButtonBright && !buttonBright) && (brightness < 224))
        brightness <= brightness + 16;
    else if ((previousButtonDim && !buttonDim) && (brightness > 0))
        brightness <= brightness - 16;

    if (counter < brightness)
        state <= 0;
    else 
        state <= 1;

    counter <= counter + 1;

    previousButtonBright <= buttonBright;
    previousButtonDim <= buttonDim;
end

assign led = state;

endmodule