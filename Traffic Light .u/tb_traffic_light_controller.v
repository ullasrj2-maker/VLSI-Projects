`timescale 1ns/1ps

module tb_traffic_light_controller;
    reg clk = 0;
    reg reset = 1;
    wire red, yellow, green;
    integer checks = 0;

    // Short intervals make the simulation quick and easy to inspect.
    traffic_light_controller #(
        .GREEN_CYCLES(3),
        .YELLOW_CYCLES(2),
        .RED_CYCLES(3)
    ) dut (
        .clk(clk), .reset(reset),
        .red(red), .yellow(yellow), .green(green)
    );

    always #5 clk = ~clk;

    task check_one_hot;
        begin
            if ((red + yellow + green) !== 1'b1)
                $fatal(1, "FAIL: outputs are not one-hot (R=%b Y=%b G=%b)", red, yellow, green);
            checks = checks + 1;
        end
    endtask

    task expect_green;
        begin
            if ({red,yellow,green} !== 3'b001)
                $fatal(1, "FAIL: expected GREEN, got R=%b Y=%b G=%b", red,yellow,green);
            check_one_hot;
        end
    endtask

    task expect_yellow;
        begin
            if ({red,yellow,green} !== 3'b010)
                $fatal(1, "FAIL: expected YELLOW, got R=%b Y=%b G=%b", red,yellow,green);
            check_one_hot;
        end
    endtask

    task expect_red;
        begin
            if ({red,yellow,green} !== 3'b100)
                $fatal(1, "FAIL: expected RED, got R=%b Y=%b G=%b", red,yellow,green);
            check_one_hot;
        end
    endtask

    initial begin
        $dumpfile("traffic_light_controller.vcd");
        $dumpvars(0, tb_traffic_light_controller);

        // Apply reset on clock edges and verify the reset state.
        repeat (2) @(posedge clk);
        #1 expect_green;
        @(negedge clk) reset = 0;

        // With 3/2/3-cycle intervals, verify the state sequence and timing.
        repeat (2) begin
            repeat (3) @(posedge clk);
            #1 expect_yellow;
            repeat (2) @(posedge clk);
            #1 expect_red;
            repeat (3) @(posedge clk);
            #1 expect_green;
        end

        $display("PASS: sequence GREEN -> YELLOW -> RED -> GREEN verified.");
        $display("PASS: one-hot output checks completed (%0d checks).", checks);
        $display("Waveform: traffic_light_controller.vcd");
        $finish;
    end
endmodule
