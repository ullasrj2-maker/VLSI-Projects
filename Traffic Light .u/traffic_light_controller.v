`timescale 1ns/1ps

module traffic_light_controller #(
    parameter integer GREEN_CYCLES  = 5,
    parameter integer YELLOW_CYCLES = 2,
    parameter integer RED_CYCLES    = 5
)(
    input wire clk,
    input wire reset,
    output reg red,
    output reg yellow,
    output reg green
);
    localparam [1:0] GREEN=2'd0, YELLOW=2'd1, RED=2'd2;
    reg [1:0] state;
    integer timer;

    always @(posedge clk) begin
        if (reset) begin
            state <= GREEN;
            timer <= 0;
        end else begin
            case (state)
                GREEN: begin
                    if (timer >= GREEN_CYCLES-1) begin
                        state <= YELLOW; timer <= 0;
                    end else timer <= timer + 1;
                end
                YELLOW: begin
                    if (timer >= YELLOW_CYCLES-1) begin
                        state <= RED; timer <= 0;
                    end else timer <= timer + 1;
                end
                RED: begin
                    if (timer >= RED_CYCLES-1) begin
                        state <= GREEN; timer <= 0;
                    end else timer <= timer + 1;
                end
                default: begin state <= GREEN; timer <= 0; end
            endcase
        end
    end

    always @(*) begin
        red=0; yellow=0; green=0;
        case (state)
            GREEN: green=1;
            YELLOW: yellow=1;
            RED: red=1;
            default: green=1;
        endcase
    end
endmodule
