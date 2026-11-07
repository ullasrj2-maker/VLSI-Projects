`timescale 1ns/1ps

// End-to-end test: connect TX directly to RX and compare each received byte.
module tb_uart_loopback;
    localparam CLK_FREQ  = 1000000;
    localparam BAUD_RATE = 100000;
    localparam CLK_PERIOD = 10;

    reg clk = 0;
    reg rst = 1;
    reg tx_start = 0;
    reg [7:0] tx_data = 0;
    wire tx;
    wire tx_busy, tx_done;
    wire [7:0] rx_data;
    wire rx_done, rx_busy, rx_error;
    integer passed = 0;
    integer failed = 0;

    uart_tx #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) tx_unit (
        .clk(clk), .rst(rst), .tx_start(tx_start), .tx_data(tx_data),
        .tx(tx), .tx_busy(tx_busy), .tx_done(tx_done)
    );

    uart_rx #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) rx_unit (
        .clk(clk), .rst(rst), .rx(tx), .rx_data(rx_data),
        .rx_done(rx_done), .rx_busy(rx_busy), .rx_error(rx_error)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    task send_byte;
        input [7:0] value;
        begin
            // Drive on falling edges so inputs are stable at the sampling edge.
            @(negedge clk);
            tx_data = value;
            tx_start = 1'b1;
            @(negedge clk);
            tx_start = 1'b0;

            wait (rx_done === 1'b1);
            if ((rx_data === value) && (rx_error === 1'b0)) begin
                passed = passed + 1;
                $display("[PASS] sent=%02h received=%02h", value, rx_data);
            end else begin
                failed = failed + 1;
                $display("[FAIL] sent=%02h received=%02h framing_error=%b", value, rx_data, rx_error);
            end
            wait (rx_busy === 1'b0);
            repeat (2) @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("sim/uart_loopback.vcd");
        $dumpvars(0, tb_uart_loopback);

        repeat (4) @(posedge clk);
        @(negedge clk); rst = 0;
        repeat (4) @(posedge clk);

        $display("\nUART TX-to-RX LOOPBACK CHECK (8N1)");
        // A mix of edge cases and bit patterns, not just one demonstration byte.
        send_byte(8'h00);
        send_byte(8'hFF);
        send_byte(8'hA5);
        send_byte(8'h3C);
        send_byte(8'h81);
        send_byte(8'h7E);
        send_byte(8'h55);
        send_byte(8'hAA);
        send_byte(8'h01);
        send_byte(8'h80);

        $display("\nResult: %0d passed, %0d failed", passed, failed);
        if ((failed == 0) && (passed == 10))
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED");
        #20 $finish;
    end

    // A stuck design should fail visibly instead of hanging forever.
    initial begin
        #2000000;
        $display("[FAIL] Testbench timeout: no completion detected.");
        $finish;
    end
endmodule
