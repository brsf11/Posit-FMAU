`timescale 1ns / 1ps
module testbench();
reg [1:0] in_pre,out_pre;
reg [31:0] A,B,C,D;
wire[31:0] out;
wire soe;
top top(A,B,C,D,in_pre,out_pre,out);
initial begin
    A = 32'b01011010010110100101101001011010;
    B = 32'b01011010010110100101101001011010;
    C = 32'b01101101010110100101101001011010;
    D = 32'b01011010010110100101101001011010;
	in_pre = 2'b00;
end
endmodule