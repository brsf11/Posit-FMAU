module SignedMultiplier8x8(input wire[7:0]   A,B,
                           output wire[15:0] out);

    wire[35:0]  gen;
    wire[3:0]   sign;

    wire[11:0] pp00;
    wire[12:0] pp01,pp02;
    wire[11:0] pp03;

    wire[13:0] pp10;
    wire[14:0] pp11;

    wire[15:0] pp20;
    wire[15:0] pp21;



    ModRadix4BoothGen MR4BG0
    #(
        .width(8)
    )
    (
        .B      ({B[1:0],1'b0}),
        .A      (A),
        .gen    (gen[8:0]),
        .sign   (sign[0])
    );

    ModRadix4BoothGen MR4BG1
    #(
        .width(8)
    )
    (
        .B      (B[3:1]),
        .A      (A),
        .gen    (gen[17:9]),
        .sign   (sign[1])
    );

    ModRadix4BoothGen MR4BG2
    #(
        .width(8)
    )
    (
        .B      ({B[5:3]),
        .A      (A),
        .gen    (gen[26:18]),
        .sign   (sign[2])
    );

    ModRadix4BoothGen MR4BG3
    #(
        .width(8)
    )
    (
        .B      ({B[7:5]),
        .A      (A),
        .gen    (gen[35:27]),
        .sign   (sign[3])
    );

endmodule