module lifNeuron #(
    parameter int DATA_WIDTH = 6,
    parameter logic [DATA_WIDTH-1:0] THRESHOLD = 'd10,
    parameter logic [DATA_WIDTH-1:0] LEAK = 'd1,
    parameter logic [DATA_WIDTH-1:0] RESET_POTENTIAL = '0

) (
    input logic clk,
    input logic resetn,

    input logic [DATA_WIDTH-1:0] inWeight,

    output logic outSpike
);

  logic [DATA_WIDTH-1:0] membranePotential;

  logic nextSpike;
  logic [DATA_WIDTH-1:0] nextPotential;

  always_comb begin
    nextPotential = membranePotential;
    nextSpike = 1'b0;

    //integrate
    if (inWeight > 0) begin
      if (membranePotential > (((2 ** DATA_WIDTH) - 1) - inWeight)) begin
        nextPotential = (2 ** DATA_WIDTH) - 1;
      end else begin
        nextPotential = membranePotential + inWeight;
      end
    end  //leak
    else if (nextPotential > '0) begin
      nextPotential = nextPotential - LEAK;
    end

    //fire
    if (nextPotential >= THRESHOLD) begin
      nextSpike = 1'b1;
      nextPotential = RESET_POTENTIAL;
    end
  end

  always_ff @(posedge clk) begin
    if (!resetn) begin
      outSpike <= 1'b0;
      membranePotential <= '0;
    end else begin
      outSpike <= nextSpike;
      membranePotential <= nextPotential;
    end
  end

endmodule
