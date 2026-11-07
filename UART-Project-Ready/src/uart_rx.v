module uart_rx #(
    parameter CLK_FREQ = 1000000,
    parameter BAUD_RATE = 100000
)(
    input clk,
    input rst,
    input rx,

    output reg [7:0] rx_data,
    output reg rx_done,
    output wire rx_busy,
    output reg rx_error
);

    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam integer HALF_BIT = CLKS_PER_BIT / 2;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    reg rx_sync1;
    reg rx_sync2;

    assign rx_busy = (state != IDLE);

    // Synchronize asynchronous RX input
    always @(posedge clk) begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            clk_count <= 0;
            bit_index <= 0;
            shift_reg <= 0;
            rx_data <= 0;
            rx_done <= 0;
            rx_error <= 0;
        end
        else begin
            rx_done <= 0;

            case (state)

                IDLE: begin
                    clk_count <= 0;
                    bit_index <= 0;
                    rx_error <= 0;

                    if (rx_sync2 == 0)
                        state <= START;
                end

                START: begin
                    if (clk_count == HALF_BIT - 1) begin
                        clk_count <= 0;

                        if (rx_sync2 == 0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                    else
                        clk_count <= clk_count + 1;
                end

                DATA: begin
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;
                        shift_reg[bit_index] <= rx_sync2;

                        if (bit_index == 7)
                            state <= STOP;
                        else
                            bit_index <= bit_index + 1;
                    end
                    else
                        clk_count <= clk_count + 1;
                end

                STOP: begin
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;

                        if (rx_sync2 == 1) begin
                            rx_data <= shift_reg;
                            rx_done <= 1;
                        end
                        else begin
                            rx_error <= 1;
                        end

                        state <= IDLE;
                    end
                    else
                        clk_count <= clk_count + 1;
                end

            endcase
        end
    end

endmodule

