module uart_tx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,

    output reg tx,
    output wire tx_busy,
    output reg tx_done
);

    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    assign tx_busy = (state != IDLE);

    always @(posedge clk) begin

        if (rst) begin
            state <= IDLE;
            tx <= 1'b1;
            tx_done <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
            shift_reg <= 0;
        end

        else begin
            tx_done <= 1'b0;

            case (state)

                IDLE: begin
                    tx <= 1'b1;
                    clk_count <= 0;
                    bit_index <= 0;

                    if (tx_start) begin
                        shift_reg <= tx_data;
                        state <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;

                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end
                    else begin
                        clk_count <= 0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    tx <= shift_reg[0];

                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end
                    else begin
                        clk_count <= 0;
                        shift_reg <= shift_reg >> 1;

                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end
                        else begin
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1;

                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end
                    else begin
                        clk_count <= 0;
                        state <= IDLE;
                        tx_done <= 1'b1;
                    end
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
