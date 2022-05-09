module UnsignedMultiplier7x7(input wire[6:0]   A,B,
                             output wire[13:0] out);
    wire[31:0]  gen;
    wire[2:0]   sign;

    wire[10:0] pp00;
    wire[11:0] pp01,pp02;
    wire[9:0]  pp03;

    wire[13:0] pp0,pp1;

    wire[15:0] tout;

    ModUnsignedRadix4BoothGen 
    #(
        .width(7)
    ) MR4BG0
    (
        .B      ({B[1:0],1'b0}),
        .A      (A),
        .gen    (gen[7:0]),
        .sign   (sign[0])
    );

    ModUnsignedRadix4BoothGen 
    #(
        .width(7)
    ) MR4BG1
    (
        .B      (B[3:1]),
        .A      (A),
        .gen    (gen[15:8]),
        .sign   (sign[1])
    );

    ModUnsignedRadix4BoothGen 
    #(
        .width(7)
    ) MR4BG2
    (
        .B      (B[5:3]),
        .A      (A),
        .gen    (gen[23:16]),
        .sign   (sign[2])
    );

    ModUnsignedRadix4BoothGen 
    #(
        .width(7)
    ) MR4BG3
    (
        .B      ({1'b0,B[6:5]}),
        .A      (A),
        .gen    (gen[31:24]),
        .sign   ()
    );


    SignextUnsigned7x7 singext
    (
        .*
    );

    WallaceTreeUnsigned7x7 wtree
    (
        .*
    );

    KSA 
    #(
        .wididx(4)
    ) adder
    (
        .A      ({2'b00,pp0}),
        .B      ({2'b00,pp1}),
        .Cin    (1'b0),
        .Sum    (tout),
        .Cout   ()
    );

    assign out = tout[13:0];

endmodule