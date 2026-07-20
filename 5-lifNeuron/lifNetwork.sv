module lifNetwork #(
    parameter int NUM_NEURONS = 64,
    parameter int DATA_WIDTH  = 6
) (
    input logic clk,
    input logic resetn,
    input logic [NUM_NEURONS-1:0] inSpike,
    output logic [NUM_NEURONS-1:0] outSpike
);

  localparam int SUMWIDTH = DATA_WIDTH + $clog2(NUM_NEURONS);

  logic [NUM_NEURONS-1:0] networkSpikes;
  logic [DATA_WIDTH-1:0] contributions[NUM_NEURONS][NUM_NEURONS];
  logic [SUMWIDTH-1:0] synapticWeights[NUM_NEURONS];

  genvar i;
  genvar j;

  generate
    for (i = 0; i < NUM_NEURONS; i++) begin : gen_neurons
      lifNeuron #(
          .DATA_WIDTH(SUMWIDTH),
          .THRESHOLD(16),
          .LEAK(1),
          .RESET_POTENTIAL(0)
      ) neuron (
          .clk(clk),
          .resetn(resetn),
          .inWeight(synapticWeights[i]),
          .outSpike(networkSpikes[i])
      );
      for (j = 0; j < NUM_NEURONS; j++) begin : gen_synapses
        lifSynapse #(
            .DATA_WIDTH(DATA_WIDTH),
            .WEIGHT(32),
            .RESET_WEIGHT(0)
        ) synapse (
            .inSpike(networkSpikes[j] | inSpike[j]),
            .weight (contributions[i][j])
        );
      end
    end
  endgenerate

  always_comb begin
    for (int k = 0; k < NUM_NEURONS; k++) begin
      synapticWeights[k] = '0;
      for (int l = 0; l < NUM_NEURONS; l++) begin
        synapticWeights[k] = synapticWeights[k] + SUMWIDTH'(contributions[k][l]);
      end
    end
  end

  assign outSpike = networkSpikes;

endmodule
