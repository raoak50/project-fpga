module lifNetwork (
    input  logic clk,
    input  logic resetn,
    input  logic inSpike,
    output logic outSpike
);

  logic [5:0] neuron1Weight;
  logic neuron1Out;
  logic [5:0] neuron2Weight;

  lifSynapse synapse1 (
      .inSpike(inSpike),
      .weight (neuron1Weight)
  );

  lifNeuron neuron1 (
      .clk(clk),
      .resetn(resetn),
      .inWeight(neuron1Weight),
      .outSpike(neuron1Out)
  );

  lifSynapse synapse2 (
      .inSpike(neuron1Out),
      .weight (neuron2Weight)
  );

  lifNeuron neuron2 (
      .clk(clk),
      .resetn(resetn),
      .inWeight(neuron2Weight),
      .outSpike(outSpike)
  );

endmodule
