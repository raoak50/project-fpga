`timescale 1ns / 1ps

module uart_loopback_tb;

  // Clock and Reset
  logic clk;
  logic rst;

  // TX Signals
  logic [7:0] tx_data;
  logic tx_send;
  logic tx_to_rx_line;  // The physical wire connecting TX to RX

  // RX Signals
  logic rx_data_valid;
  logic [7:0] rx_data;

  // Queue to hold expected values for verification
  logic [7:0] expected_data_queue[$];
  logic [7:0] current_expected;

  // 1. Instantiate Transmitter (DUT 1)
  uart_tx tx_inst (
      .clk (clk),
      .rst (rst),
      .data(tx_data),
      .send(tx_send),
      .tx  (tx_to_rx_line)
  );

  // 2. Instantiate Receiver (DUT 2)
  uart_rx rx_inst (
      .clk       (clk),
      .rst       (rst),
      .rx        (tx_to_rx_line),  // Looped back
      .data_valid(rx_data_valid),
      .data      (rx_data)
  );

  // Generate 50MHz clock (20ns period)
  always begin
    #10 clk = ~clk;
  end

  // Test stimulus task
  task automatic send_byte(input logic [7:0] byte_to_send);
    begin
      @(posedge clk);
      tx_data = byte_to_send;
      tx_send = 1;
      expected_data_queue.push_back(byte_to_send);  // Store for checking
      @(posedge clk);
      tx_send = 0;

      // Wait for transmission to completely finish before sending next
      // 10 bits * 16 ticks * 78 clock cycles = 12,480 cycles
      repeat (13000) @(posedge clk);
    end
  endtask

  // Main Simulation Loop
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    tx_data = 8'h00;
    tx_send = 0;

    // Release reset
    repeat (10) @(posedge clk);
    rst = 0;
    repeat (5) @(posedge clk);

    $display("[TB] Starting UART Loopback Test...");

    // Test Case 1: Alternating bits
    $display("[TB] Sending 8'hA5...");
    send_byte(8'hA5);

    // Test Case 2: Asymmetric bits (This reveals the MSB/LSB bug!)
    $display("[TB] Sending 8'hF0...");
    send_byte(8'hF0);

    // Test Case 3: All zeros
    $display("[TB] Sending 8'h00...");
    send_byte(8'h00);

    // Give simulation an extra moment to settle
    repeat (100) @(posedge clk);

    $display("[TB] Simulation completed.");
    $finish;
  end

  // Automated Checker: Monitors rx_data_valid and asserts correctness
  always @(posedge clk) begin
    if (rx_data_valid) begin
      if (expected_data_queue.size() == 0) begin
        $error("[CHECKER ERROR] Received unexpected data valid pulse! No data was expected.");
      end else begin
        current_expected = expected_data_queue.pop_front();
        if (rx_data === current_expected) begin
          $display("[SUCCESS] Matched! Sent: 8'h%h | Received: 8'h%h", current_expected, rx_data);
        end else begin
          $error("[FAILURE] Mismatch! Sent: 8'h%h | Received: 8'h%h (Check bit ordering!)",
                 current_expected, rx_data);
        end
      end
    end
  end

endmodule
