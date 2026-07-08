module lifSynapse (
    input logic inSpike,
    output logic [5:0] weight
);

  logic [5:0] currentWeight;

  initial begin
    currentWeight = 6'd4;
  end

  always_comb begin
    if (inSpike) begin
      weight = currentWeight;
    end else weight = 6'd0;
  end

endmodule
