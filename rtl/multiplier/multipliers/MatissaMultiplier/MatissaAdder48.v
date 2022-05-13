module MatissaAdder48(input wire[55:8]  A,B,
                      input wire        ct,
                      output wire[55:8] out);

    wire[28:0] h0a,h0b,h1a,h1b,PCh0[5:0],PCh1[5:0],Qh0[5:0],Qh1[5:0];
    wire[27:0] hout0,hout1,hout;

    wire[19:0] PCl[5:0],Ql[5:0],lout;
    wire       cl;

    genvar i,j;

    assign h0a = {A[55:28],1'b0};
    assign h0b = {B[55:28],1'b0};
    assign h1a = {A[55:28],1'b1};
    assign h1b = {B[55:28],1'b1};

    //carry select high adder
    //High adder pg gen

    generate
        for(i=0;i<29;i=i+1)begin
            PG PG0(
                .A    (h0a[i]),
                .B    (h0b[i]),
                .P    (PCh0[0][i]),
                .G    (Qh0[0][i])
            );
        end
    endgenerate

    generate
        for(i=0;i<29;i=i+1)begin
            PG PG1(
                .A    (h1a[i]),
                .B    (h1b[i]),
                .P    (PCh1[0][i]),
                .G    (Qh1[0][i])
            );
        end
    endgenerate

    //h0 P Tree

    assign PCh0[1][28:0] = PCh0[0][28:0];

    generate
        for(i=2;i<=5;i=i+1)begin
            for(j=0;j<2**(i-2);j=j+1)begin
                assign PCh0[i][j] = PCh0[i-1][j];
            end
            for(j=2**(i-2);j<29;j=j+1)begin
                assign PCh0[i][j] = PCh0[i-1][j] & PCh0[i-1][j-(2**(i-2))];
            end
        end
    endgenerate

    //Q Tree

    generate
        for(i=1;i<=5;i=i+1)begin
            for(j=0;j<2**(i-1);j=j+1)begin
                assign Qh0[i][j] = Qh0[i-1][j];
            end
            for(j=2**(i-1);j<29;j=j+1)begin
                assign Qh0[i][j] = Qh0[i-1][j] | (PCh0[i][j] & Qh0[i-1][j-(2**(i-1))]);
            end
        end
    endgenerate

    //Sum Gen

    assign hout0[27:0] = Qh0[5][27:0] ^ PCh0[0][28:1];


    //h1 P Tree

    assign PCh1[1][28:0] = PCh1[0][28:0];

    generate
        for(i=2;i<=5;i=i+1)begin
            for(j=0;j<2**(i-2);j=j+1)begin
                assign PCh1[i][j] = PCh1[i-1][j];
            end
            for(j=2**(i-2);j<29;j=j+1)begin
                assign PCh1[i][j] = PCh1[i-1][j] & PCh1[i-1][j-(2**(i-2))];
            end
        end
    endgenerate

    //Q Tree

    generate
        for(i=1;i<=5;i=i+1)begin
            for(j=0;j<2**(i-1);j=j+1)begin
                assign Qh1[i][j] = Qh1[i-1][j];
            end
            for(j=2**(i-1);j<29;j=j+1)begin
                assign Qh1[i][j] = Qh1[i-1][j] | (PCh1[i][j] & Qh1[i-1][j-(2**(i-1))]);
            end
        end
    endgenerate

    //Sum Gen

    assign hout1[27:0] = Qh1[5][27:0] ^ PCh1[0][28:1];

    //low adder
    //Low adder pg gen

    generate
        for(i=0;i<20;i=i+1)begin
            PG PG0(
                .A    (A[i+8]),
                .B    (B[i+8]),
                .P    (PCl[0][i]),
                .G    (Ql[0][i])
            );
        end
    endgenerate

    //h0 P Tree

    assign PCl[1][19:0] = PCl[0][19:0];

    generate
        for(i=2;i<=5;i=i+1)begin
            for(j=0;j<2**(i-2);j=j+1)begin
                assign PCl[i][j] = PCl[i-1][j];
            end
            for(j=2**(i-2);j<20;j=j+1)begin
                assign PCl[i][j] = PCl[i-1][j] & PCl[i-1][j-(2**(i-2))];
            end
        end
    endgenerate

    //Q Tree

    generate
        for(i=1;i<=5;i=i+1)begin
            for(j=0;j<2**(i-1);j=j+1)begin
                assign Ql[i][j] = Ql[i-1][j];
            end
            for(j=2**(i-1);j<20;j=j+1)begin
                assign Ql[i][j] = Ql[i-1][j] | (PCl[i][j] & Ql[i-1][j-(2**(i-1))]);
            end
        end
    endgenerate

    //Sum Gen

    assign lout[19:0] = {Ql[5][18:0] ^ PCl[0][19:1] , PCl[0][0]};
    assign cl         = Ql[5][19]&(~ct);


    //Carry select
    assign hout = cl?hout1:hout0;

    assign out = {hout,lout};

endmodule