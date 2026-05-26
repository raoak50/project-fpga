module UART(
    input logic clk,
    input logic [7:0] data,
    input logic send,
    output logic tx
);

typedef enum { 
    IDLE,
    START,
    TRANSMIT,
    STOP
} state_t;

logic [23:0] counter;

state_t state;
state_t next_state;

logic [3:0] bit_index;

initial begin
    state = IDLE;
    next_state = IDLE;
    tx = 1'b1;
end

always_ff @(posedge clk) begin
    state <= next_state;
    counter <= counter +1;

    if (counter > 1250) begin
        counter <= 0;
        if ( state == IDLE ) begin
            tx <= 1;
            if (send)
                next_state <= START;
            else
                next_state <= IDLE;
        end else if ( state == START ) begin 
            tx <= 0;
            next_state <= TRANSMIT;
            bit_index <= 0;
        end else if ( state == TRANSMIT ) begin
            if (bit_index > 6)
                next_state <= STOP;
            else
                next_state <= TRANSMIT;

            tx <= data[bit_index];
            bit_index <= bit_index + 1;
        end else if ( state == STOP ) begin
            tx <= 1;
            next_state <= IDLE;
        end
    end
end

endmodule
