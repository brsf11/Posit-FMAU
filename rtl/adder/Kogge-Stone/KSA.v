module KSA #(parameter wididx = 3) (input wire[2**wididx-1:0]  A,B,
                                    input wire                 Cin,
                                    output wire[2**wididx-1:0] Sum,
                                    output wire                Cout);

    wire[(wididx+1)*(2**wididx)-1:0] Q,PC;

    genvar i,j;
    generate
        for(i=0;i<2**wididx;i=i+1)begin
            PG PG0(
                .A    (A[i]),
                .B    (B[i]),
                .P    (PC[i]),
                .G    (Q[i])
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