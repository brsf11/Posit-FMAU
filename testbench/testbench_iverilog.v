`timescale 1ns/1ns
module testbench();

    reg[7:0]   A,B;
    wire[15:0] out;

    SignedMultiplier8x8 dut(
        .*
    );

    initial begin
        A = 8'd-5;
        B = 8'd60;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,testbench); 
    end

endmodule