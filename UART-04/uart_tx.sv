module uart_tx (
    input logic clk,
    input logic rst,
    input logic [7:0] data,
    input logic send,
    output logic tx
);

  logic [6:0] baud_counter;
  logic [3:0] tick_counter;
  logic baud_tick;
  logic [7:0] data_register;
  logic [2:0] bit_index;

  typedef enum {
    IDLE,
    START,
    DATA,
    STOP
  } state_t;

  state_t current_state;
  state_t next_state;

  assign baud_tick = (baud_counter == 77);

  always_comb begin
    next_state = current_state;
    case (current_state)
      IDLE: begin
        tx = 1;
        if (send) next_state = START;
      end
      START: begin
        tx = 0;
        if (baud_tick && (tick_counter == 15)) next_state = DATA;
      end
      DATA: begin
        tx = data_register[bit_index];
        if (baud_tick && (tick_counter == 15)) begin
          if (bit_index == 7) next_state = STOP;
          else next_state = DATA;
        end
      end
      STOP: begin
        tx = 1;
        if (baud_tick && (tick_counter == 15)) next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      current_state <= IDLE;
      baud_counter <= 0;
      tick_counter <= 0;
      data_register <= 0;
      bit_index <= 0;
    end else begin
      current_state <= next_state;

      if (baud_tick) baud_counter <= 0;
      else baud_counter <= baud_counter + 1;

      if (current_state == IDLE) begin
        bit_index <= 0;
        tick_counter <= 0;
        if (send) begin
          data_register <= data;
        end
      end

      if (baud_tick) begin
        if (tick_counter == 15) begin
          tick_counter <= 0;
          if (current_state == DATA) bit_index <= bit_index + 1;
        end else begin
          tick_counter <= tick_counter + 1;
        end
      end
    end
  end

endmodule
