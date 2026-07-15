module lifNetwork #(
    parameter int NUM_NEURONS = 64,
    parameter int DATA_WIDTH  = 6
) (
    input  logic clk,
    input  logic resetn,
    input  logic inSpike [NUM_NEURONS],
    output logic outSpike[NUM_NEURONS]
);

  localparam int SUMWIDTH = DATA_WIDTH + $clog2(NUM_NEURONS);

  logic networkSpikes[NUM_NEURONS];
  logic [DATA_WIDTH-1:0] contributions[NUM_NEURONS][NUM_NEURONS];
  logic [SUMWIDTH-1:0] synapticWeights[NUM_NEURONS];

  genvar i;
  genvar j;
  genvar k;

  generate
    for (i = 0; i < NUM_NEURONS; i++) begin : gen_neurons
      lifNeuron #(
          .DATA_WIDTH(DATA_WIDTH),
          .THRESHOLD(32),
          .LEAK(4),
          .RESET_POTENTIAL(0)
      ) neuron (
          .clk(clk),
          .resetn(resetn),
          .inWeight(DATA_WIDTH'(synapticWeights[i])),
          .outSpike(networkSpikes[i])
      );
      for (j = 0; j < NUM_NEURONS; j++) begin : gen_synapses
        lifSynapse #(
            .DATA_WIDTH(DATA_WIDTH),
            .WEIGHT(4),
            .RESET_WEIGHT(0)
        ) synapse (
            .inSpike(networkSpikes[i] | inSpike[i]),
            .weight (contributions[i][j])
        );
      end
    end


    for (k = 0; k < NUM_NEURONS; k++) begin : gen_accumulator
      lifAccumulator #(
          .DATA_WIDTH(DATA_WIDTH),
          .NUM_INPUTS(NUM_NEURONS)
      ) accumulator (
          .inputWeights(contributions[k]),
          .weightSum(synapticWeights[k])
      );
    end
  endgenerate

  assign outSpike = networkSpikes;

endmodule
