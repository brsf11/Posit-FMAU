module MatissaMultipleir28x28(
                            input wire[27:0]  A,B,
                            input wire[1:0]   op,
                              //output reg[55:0] out
                            output wire[13:0]  PP11,
                            output wire[20:7]  PP12,PP21,
                            output wire[27:14] PP13,PP22,PP31,
                            output wire[34:21] PP14,PP23,PP32,PP41,
                            output wire[41:28] PP24,PP33,PP42,
                            output wire[48:35] PP34,PP43,
                            output wire[55:42] PP44
                              );

    // wire[13:0]  PP11;
    // wire[20:7]  PP12,PP21;
    // wire[27:14] PP13,PP22,PP31;
    // wire[34:21] PP14,PP23,PP32,PP41;
    // wire[41:28] PP24,PP33,PP42;
    // wire[48:35] PP34,PP43;
    // wire[55:42] PP44;

    wire[223:0]  p;

    genvar i,j;

    generate
        for(i=0;i<4;i=i+1)begin
            for(j=0;j<4;j=j+1)begin
                UnsignedMultiplier7x7 mu(
                    .A      (A[i*7+6:i*7]),
                    .B      (B[j*7+6:j*7]),
                    .out    (p[i*14*4+j*14+13:i*14*4+j*14])
                );
            end
        end
    endgenerate

    MatissaPPGate28x28 gu(
        .*
    );

    //MatissaWallaceTree28x28 wtu(
    //    .*
    //);
    //
endmodule