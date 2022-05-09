module WallaceTreeUnsigned7x7(input wire[10:0]  pp00,
                              input wire[11:0]  pp01,pp02,
                              input wire[9:0]   pp03,
                              output wire[13:0] pp0,pp1);

    wire[13:0] pp10;
    wire[12:0] pp11;

    wire[13:0] pp20,pp21;

    genvar i;

    //CSA level 1

    assign pp10[1:0] = pp00[1:0];
    assign pp11[1:0] = pp01[1:0];
    assign pp11[2]   = 1'b0;

    assign pp10[13:12]  = pp02[11:10];

    generate
        for(i=2;i<=10;i=i+1)begin
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
        .x2     (pp01[11]),
        .x3     (pp02[9]),
        .s      (pp10[11]),
        .c      (pp11[12])
    );

    //CSA level 2

    assign pp20[3:0] = pp10[3:0];
    assign pp21[3:0] = pp11[3:0];
    assign pp21[4]   = 1'b0;

    generate
        for(i=4;i<=12;i=i+1)begin
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
        .x1     (pp10[13]),
        .x2     (1'b0),
        .x3     (pp03[9]),
        .s      (pp20[13]),
        .c      ()
    );

    //Output

    assign pp0 = pp20;
    assign pp1 = pp21;

endmodule