module lifNeuron (
    input logic clk,
    input logic resetn,

    input logic inSpike,

    output logic outSpike
);

  localparam logic [5:0] WEIGHT = 6'd4;
  localparam logic [5:0] THRESHOLD = 6'd10;

  logic [5:0] membranePotential;

  logic nextSpike;
  logic [5:0] nextPotential;

  always_comb begin
    nextPotential = membranePotential;
    nextSpike = 1'b0;

    //integrate
    if (inSpike) begin
      if (membranePotential > (6'd63 - WEIGHT)) begin
        nextPotential = 6'd63;
      end else begin
        nextPotential = membranePotential + WEIGHT;
      end
    end

    //leak
    if (nextPotential > 6'd0) begin
      nextPotential = nextPotential - 6'd1;
    end

    //fire
    if (nextPotential >= THRESHOLD) begin
      nextSpike = 1'b1;
      nextPotential = 6'd0;
    end
  end

  always_ff @(posedge clk) begin
    if (!resetn) begin
      outSpike <= 1'b0;
      membranePotential <= 6'd0;
    end else begin
      outSpike <= nextSpike;
      membranePotential <= nextPotential;
    end
  end

endmodule
