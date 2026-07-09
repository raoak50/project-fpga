`timescale 1ns / 1ps

module tb_lifNetwork ();

  logic clk;
  logic resetn;
  logic inSpike;
  logic outSpike;

  lifNetwork uut (
      .clk(clk),
      .resetn(resetn),
      .inSpike(inSpike),
      .outSpike(outSpike)
  );

  // 100 MHz clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Dump waveforms for GTKWave
  initial begin
    $dumpfile("lifNetwork.vcd");
    $dumpvars(0, tb_lifNetwork);
  end

  initial begin

    // Initial values
    resetn  = 0;
    inSpike = 0;

    // Hold reset for a few clocks
    repeat (3) @(posedge clk);
    resetn = 1;

    // -------------------------
    // Single spike
    // -------------------------
    @(posedge clk);
    inSpike = 1;

    @(posedge clk);
    inSpike = 0;

    // Wait for leak
    repeat (10) @(posedge clk);

    // -------------------------
    // Burst of spikes
    // -------------------------
    repeat (10) begin
      @(posedge clk);
      inSpike = 1;

      @(posedge clk);
      inSpike = 0;
    end

    // Allow activity to propagate
    repeat (20) @(posedge clk);

    $finish;
  end

endmodule
