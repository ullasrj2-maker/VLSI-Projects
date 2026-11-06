`timescale 1ns/1ps

module tb_alu;

reg [7:0] A, B;
reg [2:0] Sel;

wire [7:0] Result;
wire CarryOut, Zero;

alu uut (
    .A(A),
    .B(B),
    .Sel(Sel),
    .Result(Result),
    .CarryOut(CarryOut),
    .Zero(Zero)
);

initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, tb_alu);

    A = 15; B = 10; Sel = 3'b000; #10;
    $display("Addition = %d", Result);

    A = 20; B = 5; Sel = 3'b001; #10;
    $display("Subtraction = %d", Result);

    A = 8'hCC; B = 8'hAA; Sel = 3'b010; #10;
    $display("AND = %b", Result);

    Sel = 3'b011; #10;
    $display("OR = %b", Result);

    Sel = 3'b100; #10;
    $display("XOR = %b", Result);

    A = 0; B = 0; Sel = 3'b000; #10;
    $display("Zero = %b", Zero);

    $finish;
end

endmodule
