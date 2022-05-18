`timescale 1ns/1ns
module testbench_mm();

    reg[27:0]   A,B;
    reg[1:0]    op;
    wire[55:0]  out;

    MatissaMultipleir28x28 dut(
        .*
    );

    initial begin
        A = 28'd268_435_455;
        B = 28'd268_435_455;
        op = 2'b00;
        #50;
        op = 2'b01;
        #50;
        op = 2'b10;
    end

endmodule