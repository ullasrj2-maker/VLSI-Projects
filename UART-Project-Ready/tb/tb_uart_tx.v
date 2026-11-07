`timescale 1ns/1ps

module tb_uart_tx;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;
    wire tx_done;

    localparam CLK_FREQ = 1000000;
    localparam BAUD_RATE = 100000;
    localparam BIT_PERIOD = 100;

    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("sim/uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        clk = 0;
        rst = 1;
        tx_start = 0;
        tx_data = 8'hA5;

        #20;
        rst = 0;

        #20;
        tx_start = 1;

        #10;
        tx_start = 0;

        $display("UART Transmission Started");

        @(negedge tx);

        #50;

        $display("Start Bit: %b", tx);

        repeat (8) begin
            #100;
            $display("Data Bit: %b", tx);
        end

        #100;
        $display("Stop Bit: %b", tx);

        wait(tx_done);

        $display("Transmission Completed!");

        #50;
        $finish;

    end

endmodule
