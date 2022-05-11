module MatissaAdder48(input wire[55:8]  A,B,
                      input wire        ct,
                      output wire[55:8] out);

    wire[28:0] h0a,h0b,h1a,h1b,PCh0,PCh1,Qh0,Qh1;
    wire[27:0] hout0,hout1,hout;

    wire[19:0] PCl,Ql;
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
                .P    (PCh0[i]),
                .G    (Qh0[i])
            );
        end
    endgenerate

    generate
        for(i=0;i<29;i=i+1)begin
            PG PG1(
                .A    (h1a[i]),
                .B    (h1b[i]),
                .P    (PCh1[i]),
                .G    (Qh1[i])
            );
        end
    endgenerate

    //P Tree

    assign PC[1*(2**wididx)+2**wididx-1:1*(2**wididx)] = PC[0*(2**wididx)+2**wididx-1:0];

    generate
        for(i=2;i<=wididx;i=i+1)begin
            for(j=0;j<2**(i-2);j=j+1)begin
                assign PC[i*(2**wididx)+j] = PC[(i-1)*(2**wididx)+j];
            end
            for(j=2**(i-2);j<2**wididx;j=j+1)begin
                assign PC[i*(2**wididx)+j] = PC[(i-1)*(2**wididx)+j] & PC[(i-1)*(2**wididx)+j-(2**(i-2))];
            end
        end
    endgenerate

    //Q Tree

    generate
        for(i=1;i<=wididx;i=i+1)begin
            for(j=0;j<2**(i-1);j=j+1)begin
                assign Q[i*(2**wididx)+j] = Q[(i-1)*(2**wididx)+j];
            end
            for(j=2**(i-1);j<2**wididx;j=j+1)begin
                assign Q[i*(2**wididx)+j] = Q[(i-1)*(2**wididx)+j] | (PC[i*(2**wididx)+j] & Q[(i-1)*(2**wididx)+j-(2**(i-1))]);
            end
        end
    endgenerate

    //Sum Gen

    assign Sum[2**wididx-1:0] = {Q[wididx*(2**wididx)+2**wididx-2:wididx*(2**wididx)] ^ PC[2**wididx-1:1] , PC[0]};
    assign Cout = Q[wididx*(2**wididx)+2**wididx-1];


endmodule