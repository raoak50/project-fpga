module uart_rx (
    input logic clk,
    input logic rst,
    input logic rx,

    output logic data_valid,
    output logic [7:0] data
);

  typedef enum {
    IDLE,
    START,
    DATA,
    STOP
  } state_t;

  logic [6:0] baud_counter;
  logic baud_tick;
  logic [3:0] tick_counter;

  logic [2:0] bit_index;
  logic [7:0] data_shifter;

  assign baud_tick = (baud_counter == 77);

  state_t current_state;

  always_ff @(posedge clk) begin
    if (rst) begin
      current_state <= IDLE;
      bit_index <= 0;
      tick_counter <= 0;
      data_shifter <= 0;
      baud_counter <= 0;
      data_valid <= 0;
    end else begin
      if (baud_tick) baud_counter <= 0;
      else baud_counter <= baud_counter + 1;

      if (baud_tick) begin
        case (current_state)
          IDLE: begin
            data_valid <= 0;
            tick_counter <= 0;
            bit_index <= 0;
            baud_counter <= 0;
            data_shifter <= 0;

            if (rx == 0) begin
              current_state <= START;
            end
          end
          START: begin
            if (tick_counter == 7) begin
              current_state <= DATA;
              tick_counter  <= 0;
            end else begin
              tick_counter <= tick_counter + 1;
            end
          end
          DATA: begin
            if (tick_counter == 15) begin
              data_shifter[bit_index] <= rx;
              tick_counter <= 0;
              if (bit_index == 7) begin
                current_state <= STOP;
              end else begin
                current_state <= DATA;
                bit_index <= bit_index + 1;
              end
            end else begin
              tick_counter <= tick_counter + 1;
            end
          end
          STOP: begin
            if (tick_counter == 15) begin
              current_state <= IDLE;
              data <= data_shifter;
              data_valid <= 1'b1;
              tick_counter <= 0;
            end else begin
              tick_counter <= tick_counter + 1;
            end
          end
          default: current_state <= IDLE;
        endcase
      end else begin
        data_valid <= 1'b0;
      end
    end
  end


endmodule
