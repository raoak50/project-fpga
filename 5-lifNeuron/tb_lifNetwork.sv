`timescale 1ns / 1ps

module tb_lifNetwork;

  localparam int NUM_NEURONS = 4;
  localparam int DATA_WIDTH = 6;

  logic clk;
  logic resetn;

  logic inSpike [NUM_NEURONS];
  logic outSpike[NUM_NEURONS];

  lifNetwork #(
      .NUM_NEURONS(NUM_NEURONS),
      .DATA_WIDTH (DATA_WIDTH)
  ) dut (
      .clk(clk),
      .resetn(resetn),
      .inSpike(inSpike),
      .outSpike(outSpike)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $dumpfile("lifNetwork.vcd");
    $dumpvars(0, tb_lifNetwork);

    resetn = 0;

    foreach (inSpike[i]) inSpike[i] = 0;

    repeat (2) @(posedge clk);

    resetn = 1;

    @(posedge clk);
    inSpike[0] = 1;

    @(posedge clk);
    inSpike[0] = 0;

    repeat (10) @(posedge clk);

    @(posedge clk);
    inSpike[1] = 1;
    inSpike[2] = 1;

    @(posedge clk);
    inSpike[1] = 0;
    inSpike[2] = 0;

    repeat (20) @(posedge clk);

    repeat (20) begin
      @(posedge clk);

      foreach (inSpike[i]) inSpike[i] = ($urandom_range(0, 1) != 0);
    end

    @(posedge clk);

    foreach (inSpike[i]) inSpike[i] = 0;

    repeat (20) @(posedge clk);

    $finish;

  end

endmodule
