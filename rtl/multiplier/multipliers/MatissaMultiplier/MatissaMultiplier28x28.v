module MatissaMultipleir28x28(input wire[27:0]  A,B,
                              input wire[1:0]   op,
                              output wire[55:0] out);

    wire[13:0]  PP11;
    wire[20:7]  PP12,PP21;
    wire[27:14] PP13,PP22,PP31;
    wire[34:21] PP14,PP23,PP32,PP41;
    wire[41:28] PP24,PP33,PP42;
    wire[48:35] PP34,PP43;
    wire[55:42] PP44;

    wire[13:0]  pp[3:0][3:0];

    genvar i,j;

    generate
        for(i=0;i<4;i=i+1)begin
            for(j=0;j<4;j=j+1)begin
                UnsignedMultiplier7x7 mu(
                    .A      (A[i*4+3:i*4]),
                    .B      (B[i*4+3:i*4]),
                    .out    (pp[i][j])
                );
            end
        end
    endgenerate

    MatissaPPGate28x28 gu(
        .*
    );

    MatissaWallaceTree28x28 wtu(
        .*
    );

endmodule