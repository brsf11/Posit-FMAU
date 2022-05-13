`timescale 1ns/1ns
module testbench_ma();

    reg[47:0]   A,B;
    reg         ct;
    wire[47:0]  out;

    MatissaAdder48 dut(
        .*
    );

    initial begin
        A = 48'd24117148;
        B = 48'd502749084;
        ct = 0;
        #50;
        ct = 1;
    end

endmodule