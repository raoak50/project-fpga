module lifNetwork (
    input  logic clk,
    input  logic resetn,
    input  logic inSpike,
    output logic outSpike
);

  logic [5:0] neuron1Weight;
  logic neuron1Out;
  logic [5:0] neuron2Weight;
  logic neuron2Out;
  logic [5:0] neuron3Weight;
  logic neuron3Out;
  logic [5:0] neuron4Weight1;
  logic [5:0] neuron4Weight2;

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

  lifSynapse synapse3 (
      .inSpike(neuron1Out),
      .weight (neuron3Weight)
  );

  lifNeuron neuron2 (
      .clk(clk),
      .resetn(resetn),
      .inWeight(neuron2Weight),
      .outSpike(neuron2Out)
  );

  lifNeuron neuron3 (
      .clk(clk),
      .resetn(resetn),
      .inWeight(neuron3Weight),
      .outSpike(neuron3Out)
  );

  lifSynapse synapse4 (
      .inSpike(neuron2Out),
      .weight (neuron4Weight1)
  );

  lifSynapse synapse5 (
      .inSpike(neuron3Out),
      .weight (neuron4Weight2)
  );

  lifNeuron neuron4 (
      .clk(clk),
      .resetn(resetn),
      .inWeight(neuron4Weight1 + neuron4Weight2),
      .outSpike(outSpike)
  );


endmodule
