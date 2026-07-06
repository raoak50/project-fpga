`timescale 1ns / 1ps

module tb_uart;

  // Clock & Reset
  logic clk;
  logic rst;

  // Interconnects
  logic [7:0] tx_data;
  logic tx_send;
  logic tx_to_rx_line;  // Direct wire from TX to RX

  logic rx_data_valid;
  logic [7:0] rx_data;

  // Instantiate Transmitter
  uart_tx tx_inst (
      .clk (clk),
      .rst (rst),
      .data(tx_data),
      .send(tx_send),
      .tx  (tx_to_rx_line)
  );

  // Instantiate Receiver
  uart_rx rx_inst (
      .clk       (clk),
      .rst       (rst),
      .rx        (tx_to_rx_line),
      .data_valid(rx_data_valid),
      .data      (rx_data)
  );

  // Create 50MHz Clock (20ns period)
  always begin
    #10 clk = ~clk;
  end

  // Clean Task to handle byte transmission
  task automatic send_byte(input logic [7:0] data_byte);
    begin
      @(posedge clk);
      tx_data = data_byte;
      tx_send = 1;
      @(posedge clk);
      tx_send = 0;

      // Wait for complete 10-bit frame (12,480 cycles total)
      repeat (13000) @(posedge clk);

      // Extra breathing room between packets (approx 200 cycles)
      repeat (200) @(posedge clk);
    end
  endtask

  // Simulation Sequence
  initial begin
    // Setup for GTKWave waveform collection
    $dumpfile("uart_waves.vcd");
    $dumpvars(0, tb_uart);

    // Initial State Configuration
    clk = 0;
    rst = 1;
    tx_data = 8'h00;
    tx_send = 0;

    // Hold Reset
    repeat (10) @(posedge clk);
    rst = 0;
    repeat (5) @(posedge clk);

    $display("[TB] --- Starting Clean UART Simulation ---");

    // Send 3 distinct test bytes sequentially
    $display("[TB] Sending Byte 1: 8'hAC");
    send_byte(8'hAC);

    $display("[TB] Sending Byte 2: 8'h55");
    send_byte(8'h55);

    $display("[TB] Sending Byte 3: 8'hF0");
    send_byte(8'hF0);

    repeat (500) @(posedge clk);
    $display("[TB] --- Simulation Run Completed ---");
    $finish;
  end

  // Monitor Terminal Output Block
  always @(posedge clk) begin
    if (rx_data_valid) begin
      $display("[TB MONITOR] Received Byte = 8'h%h", rx_data);
    end
  end

endmodule
