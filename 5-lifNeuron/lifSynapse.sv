module lifSynapse #(
    parameter int DATA_WIDTH = 6,
    parameter logic [DATA_WIDTH-1:0] WEIGHT = 7,
    parameter logic [DATA_WIDTH-1:0] RESET_WEIGHT = 0
) (
    input logic inSpike,
    output logic [DATA_WIDTH-1:0] weight
);

  always_comb begin
    if (inSpike) begin
      weight = WEIGHT;
    end else weight = RESET_WEIGHT;
  end

endmodule
