module SignedMultiplier8x8(input wire[7:0]   A,B,
                           output wire[15:0] out);

    wire[35:0]  gen;
    wire[3:0]   sign;

    wire[11:0] pp00,pp03;
    wire[12:0] pp01,pp02;

    wire[15:0] pp0,pp1;

    ModRadix4BoothGen 
    #(
        .width(8)
    ) MR4BG0
    (
        .B      ({B[1:0],1'b0}),
        .A      (A),
        .gen    (gen[8:0]),
        .sign   (sign[0])
    );

    ModRadix4BoothGen 
    #(
        .width(8)
    ) MR4BG1
    (
        .B      (B[3:1]),
        .A      (A),
        .gen    (gen[17:9]),
        .sign   (sign[1])
    );

    ModRadix4BoothGen 
    #(
        .width(8)
    ) MR4BG2
    (
        .B      (B[5:3]),
        .A      (A),
        .gen    (gen[26:18]),
        .sign   (sign[2])
    );

    ModRadix4BoothGen 
    #(
        .width(8)
    ) MR4BG3
    (
        .B      (B[7:5]),
        .A      (A),
        .gen    (gen[35:27]),
        .sign   (sign[3])
    );


    SignextSigned8x8 singext
    (
        .*
    );

    WallaceTreeSigned8x8 wtree
    (
        .sign3  (sign[3]),
        .*
    );

    KSA 
    #(
        .wididx(4)
    ) adder
    (
        .A      (pp0),
        .B      (pp1),
        .Cin    (1'b0),
        .Sum    (out),
        .Cout   ()
    );

endmodule