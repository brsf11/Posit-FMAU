`timescale 1ns/1ns
module testbench_u77();

    reg[6:0]   A,B;
    wire[13:0] out;

    UnsignedMultiplier7x7 dut(
        .*
    );

    initial begin
        A = 7'b111_1100;
        B = 7'b111_0011;
    end

endmodule