`timescale 1ns/1ps
module full_adder(input wire A,B,Cin, output wire Sum,Cout);
  assign Sum = A ^ B ^ Cin;
  assign Cout = (A&B) | (A&Cin) | (B&Cin);
endmodule
