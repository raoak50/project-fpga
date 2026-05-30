module tb_uart;

  logic clk;
  logic rst;
  logic [7:0] data;
  logic send;
  logic tx;

  uart dut (
      .clk (clk),
      .rst (rst),
      .data(data),
      .send(send),
      .tx  (tx)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, tb_uart);

    clk  = 0;
    send = 0;
    rst  = 1;
    data = 8'b10100101;

    #20;
    rst  = 0;
    send = 1;

    #20;
    send = 0;

    #150000;

    $finish;
  end

endmodule
