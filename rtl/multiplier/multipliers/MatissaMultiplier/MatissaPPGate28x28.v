module MatissaPPGate28x28(input wire[223:0]  p,
                          input wire[1:0]    op,
                          output reg[13:0]   PP11,
                          output reg[20:7]   PP12,PP21,
                          output reg[27:14]  PP13,PP22,PP31,
                          output reg[34:21]  PP14,PP23,PP32,PP41,
                          output reg[41:28]  PP24,PP33,PP42,
                          output reg[48:35]  PP34,PP43,
                          output reg[55:42]  PP44);

    wire[13:0] pp[3:0][3:0];

    genvar i,j;

    generate
        for(i=0;i<4;i=i+1)begin
            for(j=0;j<4;j=j+1)begin
                assign pp[i][j][13:0] = p[i*14*4+j*14+13:i*14*4+j*14];
            end
        end
    endgenerate

    always @(*) begin
        case(op)
            2'b00:begin
                PP11 = pp[0][0];
                PP12 = 14'b0;
                PP13 = 14'b0;
                PP14 = 14'b0;
                PP21 = 14'b0;
                PP22 = pp[1][1];
                PP23 = 14'b0;
                PP24 = 14'b0;
                PP31 = 14'b0;
                PP32 = 14'b0;
                PP33 = pp[2][2];
                PP34 = 14'b0;
                PP41 = 14'b0;
                PP42 = 14'b0;
                PP43 = 14'b0;
                PP44 = pp[3][3];
            end
            2'b01:begin
                PP11 = pp[0][0];
                PP12 = pp[0][1];
                PP13 = 14'b0;
                PP14 = 14'b0;
                PP21 = pp[1][0];
                PP22 = pp[1][1];
                PP23 = 14'b0;
                PP24 = 14'b0;
                PP31 = 14'b0;
                PP32 = 14'b0;
                PP33 = pp[2][2];
                PP34 = pp[2][3];
                PP41 = 14'b0;
                PP42 = 14'b0;
                PP43 = pp[3][2];
                PP44 = pp[3][3];
            end
            2'b10:begin
                PP11 = pp[0][0];
                PP12 = pp[0][1];
                PP13 = pp[0][2];
                PP14 = pp[0][3];
                PP21 = pp[1][0];
                PP22 = pp[1][1];
                PP23 = pp[1][2];
                PP24 = pp[1][3];
                PP31 = pp[2][0];
                PP32 = pp[2][1];
                PP33 = pp[2][2];
                PP34 = pp[2][3];
                PP41 = pp[3][0];
                PP42 = pp[3][1];
                PP43 = pp[3][2];
                PP44 = pp[3][3];
            end
            default:begin
                PP11 = 14'b0;
                PP12 = 14'b0;
                PP13 = 14'b0;
                PP14 = 14'b0;
                PP21 = 14'b0;
                PP22 = 14'b0;
                PP23 = 14'b0;
                PP24 = 14'b0;
                PP31 = 14'b0;
                PP32 = 14'b0;
                PP33 = 14'b0;
                PP34 = 14'b0;
                PP41 = 14'b0;
                PP42 = 14'b0;
                PP43 = 14'b0;
                PP44 = 14'b0;
            end
        endcase
    end

endmodule