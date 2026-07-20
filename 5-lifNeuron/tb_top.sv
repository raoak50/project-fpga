`timescale 1ns / 1ps

module tb_top;

  logic clk;
  logic resetn;
  logic button;
  logic [3:0] led;

  top dut (
      .clk(clk),
      .resetn(resetn),
      .button(button),
      .led(led)
  );

  initial clk = 0;
  always #5 clk = ~clk;


  initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, tb_top);

    // Initialize inputs
    resetn = 0;
    button = 1;  // Idle state for active-low is High

    // Hold reset for a few cycles
    repeat (5) @(posedge clk);
    resetn = 1;
    repeat (5) @(posedge clk);

    // --- TEST ACTION: Clean Button Press ---
    $display("Pressing button...");
    button = 0;  // Press (Active-Low)

    // Hold it down for 10 cycles (longer than COUNT_MAX = 5)
    repeat (10) @(posedge clk);

    $display("Releasing button...");
    button = 1;  // Release

    // Wait long enough to see the network process and the LED stretch
    repeat (50) @(posedge clk);

    $finish;
  end

endmodule














