module tb_uart;

logic clk;
logic [7:0] data;
logic send;
logic tx;

UART dut (
    .clk(clk),
    .data(data),
    .send(send),
    .tx(tx)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, tb_uart);

    clk = 0;
    send = 0;
    data = 8'b10100101;

    #20;
    send = 1;

    #10;
    send = 0;

    #50000;

    $finish;
end

endmodule
