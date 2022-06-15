`timescale 1ns / 1ps
module testbench();
reg [1:0] in_pre,out_pre;
reg [31:0] A,B,C,D;
wire[31:0] out;
wire soe;
reg clk=0;
top top(clk,A,B,C,D,in_pre,out_pre,out);
initial begin
    A = 32'h4a51eb85;
    B = 32'h651547ae;
    C = 32'h74401999;
    D = 32'h1e666666;
	in_pre = 2'b10;
end

always #10 clk <= ~clk;
endmodule