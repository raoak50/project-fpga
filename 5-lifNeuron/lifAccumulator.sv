module lifAccumulator #(
    parameter int DATA_WIDTH = 6,
    parameter int NUM_INPUTS = 64
) (
    input logic [DATA_WIDTH-1:0] inputWeights[NUM_INPUTS],
    output logic [DATA_WIDTH + $clog2(NUM_INPUTS)-1:0] weightSum
);

  localparam int SUMWIDTH = DATA_WIDTH + $clog2(NUM_INPUTS);

  logic [SUMWIDTH-1:0] weightRegister;


  always_comb begin
    weightRegister = '0;
    for (int i = 0; i < NUM_INPUTS; i++) begin
      weightRegister = weightRegister + (SUMWIDTH - 1)'(inputWeights[i]);
    end

    weightSum = weightRegister;
  end
endmodule
