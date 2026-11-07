`timescale 1ns/1ps

module tb_uart_rx;

    reg clk;
    reg rst;
    reg rx;

    wire [7:0] rx_data;
    wire rx_done;
    wire rx_busy;
    wire rx_error;

    localparam BIT_PERIOD = 100;

    uart_rx #(
        .CLK_FREQ(1000000),
        .BAUD_RATE(100000)
    ) uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .rx_busy(rx_busy),
        .rx_error(rx_error)
    );

    always #5 clk = ~clk;

    task send_byte;
        input [7:0] data;
        integer i;
        begin
            rx = 0;
            #(BIT_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD);
            end

            rx = 1;
            #(BIT_PERIOD);
        end
    endtask

    initial begin
        $dumpfile("sim/uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);

        clk = 0;
        rst = 1;
        rx = 1;

        #20;
        rst = 0;

        $display("UART RX Test Started");

        fork
            send_byte(8'hA5);

            begin
                wait(rx_done);

                $display("Received Data: %h", rx_data);

                if (rx_data == 8'hA5 && rx_error == 0)
                    $display("PASS: UART RX Working Correctly!");
                else
                    $display("FAIL: UART RX Error!");
            end
        join

        #50;
        $finish;
    end

endmodule
       
