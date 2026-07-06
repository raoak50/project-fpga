`timescale 1ns / 1ps

module lifNeuron_tb;

  logic clk;
  logic resetn;
  logic inSpike;
  logic outSpike;


  lifNeuron uut (
      .clk(clk),
      .resetn(resetn),
      .inSpike(inSpike),
      .outSpike(outSpike)
  );

  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end


  initial begin
    $dumpfile("lifNueron_sim.vcd");
    $dumpvars(0, lifNeuron_tb);

    resetn  = 0;
    inSpike = 0;

    #15;
    resetn = 1;

    #10;
    inSpike = 1;
    #10;
    inSpike = 0;

    #10;
    inSpike = 1;
    #10;
    inSpike = 0;

    #10;
    inSpike = 1;
    #10;
    inSpike = 0;

    #50;

    $display("Simulation Finished!");
    $finish;
  end

endmodule
