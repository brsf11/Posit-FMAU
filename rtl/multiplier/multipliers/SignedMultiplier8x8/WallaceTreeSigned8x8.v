module WallaceTreeSigned8x8(input wire[11:0]  pp00,pp03,
                            input wire[12:0]  pp01,pp02,
                            input wire        sign3,
                            output wire[15:0] pp0,pp1);

    wire[14:0] pp10;
    wire[13:0] pp11;

    wire[15:0] pp20,pp21;
    
    wire[15:0] pp30,pp31;

    genvar i;

    //CSA level 1

    assign pp10[1:0] = pp00[1:0];
    assign pp11[1:0] = pp01[1:0];
    assign pp11[2]   = 1'b0;

    assign pp10[14:13]  = pp02[12:11];

    generate
        for(i=2;i<=11;i=i+1)begin
            Compressor32 cp0
            (
                .x1     (pp00[i]),
                .x2     (pp01[i]),
                .x3     (pp02[i-2]),
                .s      (pp10[i]),
                .c      (pp11[i+1])
            );
        end
    endgenerate
    
    Compressor32 cp01
    (
        .x1     (1'b0),
        .x2     (pp01[12]),
        .x3     (pp02[10]),
        .s      (pp10[12]),
        .c      (pp11[13])
    );

    //CSA level 2

    assign pp20[3:0] = pp10[3:0];
    assign pp21[3:0] = pp11[3:0];
    assign pp21[4]   = 1'b0;

    assign pp20[15]  = pp03[11];

    generate
        for(i=4;i<=13;i=i+1)begin
            Compressor32 cp1
            (
                .x1     (pp10[i]),
                .x2     (pp11[i]),
                .x3     (pp03[i-4]),
                .s      (pp20[i]),
                .c      (pp21[i+1])
            );
        end
    endgenerate

    Compressor32 cp11
    (
        .x1     (pp10[14]),
        .x2     (1'b0),
        .x3     (pp03[10]),
        .s      (pp20[14]),
        .c      (pp21[15])
    );

    //CSA level 3

    assign pp30[5:0] = pp20[5:0];
    assign pp31[5:0] = pp21[5:0];
    assign pp31[6]   = 1'b0;

    assign pp30[15]  = pp20[15];

    Compressor32 cp20
    (
        .x1     (pp20[6]),
        .x2     (pp21[6]),
        .x3     (sign3),
        .s      (pp30[6]),
        .c      (pp31[7])
    );

    generate
        for(i=7;i<=14;i=i+1)begin
            Compressor32 cp2
            (
                .x1     (pp20[i]),
                .x2     (pp21[i]),
                .x3     (1'b0),
                .s      (pp30[i]),
                .c      (pp31[i+1])
            );
        end
    endgenerate

    Compressor32 cp21
    (
        .x1     (pp20[15]),
        .x2     (pp21[15]),
        .x3     (1'b0),
        .s      (pp30[15]),
        .c      ()
    );

    //Output

    assign pp0 = pp30;
    assign pp1 = pp31;

endmodule