module lifNeuron (
    input logic clk,
    input logic resetn,

    input logic inSpike,

    output logic outSpike
);

  logic [5:0] weight;

  logic [5:0] membranePotential;

  logic nextSpike;
  logic [5:0] nextPotential;

  initial begin
    weight = 4;
  end

  always_comb begin
    nextPotential = membranePotential;
    nextSpike = outSpike;
    if (inSpike && membranePotential < 10) begin
      nextPotential = membranePotential + weight;
    end else if (membranePotential >= 10 && inSpike) begin
      nextSpike = 1;
      nextPotential = 0;
    end
  end

  always_ff @(posedge clk) begin
    if (resetn) begin
      outSpike <= 0;
      membranePotential <= 0;
    end else if (inSpike) begin
      outSpike <= nextSpike;
      membranePotential <= nextPotential;
    end else begin
      membranePotential <= membranePotential;
      if (membranePotential > 0) membranePotential <= membranePotential - 1;
    end
  end

endmodule
