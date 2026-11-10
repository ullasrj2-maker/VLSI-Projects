`timescale 1ns/1ps
module tb_four_bit_adder;
  reg [3:0] A,B; reg Cin;
  wire [3:0] Sum; wire Cout;
  integer a,b,c;
  four_bit_adder dut(A,B,Cin,Sum,Cout);
  initial begin
    $dumpfile("four_bit_adder.vcd"); $dumpvars(0,tb_four_bit_adder);
    for(a=0;a<16;a=a+1)
      for(b=0;b<16;b=b+1)
        for(c=0;c<2;c=c+1) begin
          A=a; B=b; Cin=c; #1;
          if ({Cout,Sum} !== (a+b+c))
            $fatal(1,"FAIL: A=%0d B=%0d Cin=%0d got=%0d expected=%0d",a,b,c,{Cout,Sum},a+b+c);
        end
    $display("PASS: all 512 input combinations verified.");
    $finish;
  end
endmodule
