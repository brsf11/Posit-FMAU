module MatissaWallaceTree28x28(input wire[13:0]  PP11,
                               input wire[20:7]  PP12,PP21,
                               input wire[27:14] PP13,PP22,PP31,
                               input wire[34:21] PP14,PP23,PP32,PP41,
                               input wire[41:28] PP24,PP33,PP42,
                               input wire[48:35] PP34,PP43,
                               input wire[55:42] PP44,
                               input wire[1:0]   op,
                               output wire[55:0] out);

    wire[55:8]  P0;
    wire[49:8]  P1;
    wire[43:16] P2;
    wire[49:16] P3;
    wire[50:17] P4;

    genvar i;

    //CSA level 1

    assign out[6:0] = PP11[6:0];

    Compressor32 C320
    (
        .x1     (PP11[7]),
        .x2     (PP12[7]),
        .x3     (PP21[7]),
        .s      (out[7]),
        .c      (P1[8])
    );

    generate
        for(i=8;i<=13;i=i+1)begin
            Compressor32 C321
            (
                .x1     (PP11[i]),
                .x2     (PP12[i]),
                .x3     (PP21[i]),
                .s      (P0[i]),
                .c      (P1[i+1])
            );
        end
    endgenerate

    generate
        for(i=14;i<=20;i=i+1)begin
            Compressor53 C530
            (
                .x1     (PP13[i]),
                .x2     (PP12[i]),
                .x3     (PP21[i]),
                .x4     (PP22[i]),
                .x5     (PP31[i]),
                .s      (P0[i]),
                .c1     (P1[i+1]),
                .c2     (P2[i+2])
            );
        end
    endgenerate

    generate
        for(i=21;i<=27;i=i+1)begin
            Compressor73 C730
            (
                .x1     (PP13[i]),
                .x2     (PP14[i]),
                .x3     (PP23[i]),
                .x4     (PP22[i]),
                .x5     (PP31[i]),
                .x6     (PP32[i]),
                .x7     (PP41[i]),
                .s      (P0[i]),
                .c1     (P1[i+1]),
                .c2     (P2[i+2])
            );
        end
    endgenerate

    generate
        for(i=28;i<=34;i=i+1)begin
            Compressor73 C731
            (
                .x1     (PP14[i]),
                .x2     (PP23[i]),
                .x3     (PP24[i]),
                .x4     (PP33[i]),
                .x5     (PP32[i]),
                .x6     (PP41[i]),
                .x7     (PP42[i]),
                .s      (P0[i]),
                .c1     (P1[i+1]),
                .c2     (P2[i+2])
            );
        end
    endgenerate

    generate
        for(i=35;i<=41;i=i+1)begin
            Compressor53 C531
            (
                .x1     (PP24[i]),
                .x2     (PP33[i]),
                .x3     (PP34[i]),
                .x4     (PP43[i]),
                .x5     (PP42[i]),
                .s      (P0[i]),
                .c1     (P1[i+1]),
                .c2     (P2[i+2])
            );
        end
    endgenerate

    generate
        for(i=42;i<=48;i=i+1)begin
            Compressor32 C322
            (
                .x1     (PP34[i]),
                .x2     (PP43[i]),
                .x3     (PP44[i]),
                .s      (P0[i]),
                .c      (P1[i+1])
            );
        end
    endgenerate

    assign P0[55:49] = PP44[55:49];

    //CSA level 2

    generate
        for(i=16;i<=43;i=i+1)begin
            Compressor32 C323
            (
                .x1     (P0[i]),
                .x2     (P1[i]),
                .x3     (P2[i]),
                .s      (P3[i]),
                .c      (P4[i+1])
            );
        end
    endgenerate

    generate
        for(i=44;i<=49;i=i+1)begin
            Compressor32 C323
            (
                .x1     (P0[i]),
                .x2     (P1[i]),
                .x3     (1'b0),
                .s      (P3[i]),
                .c      (P4[i+1])
            );
        end
    endgenerate


    //Adder

    wire ct;

    assign ct = (op == 2'b00) | (op == 2'b01);

    MatissaAdder48 madder(
        .A      ({P0[55:50],P3[49:16],P0[15:8]}),
        .B      ({5'b0,P4[50:17],1'b0,P1[15:8]}),
        .ct     (ct),
        .out    (out[55:8])
    );

endmodule