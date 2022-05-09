module ModUnsignedRadix4BoothGen #(
    parameter width = 8
)
(
    input wire[2:0]       B,
    input wire[width-1:0] A,
    output reg[width:0]   gen,
    output reg            sign
);

    wire[width-1:0] negA;

    assign negA = ~A;

    always @(*) begin
        case(B)
            3'b000:  sign = 1'b0;
            3'b001:  sign = 1'b0;
            3'b010:  sign = 1'b0;
            3'b011:  sign = 1'b0;
            3'b100:  sign = 1'b1;
            3'b101:  sign = 1'b1;
            3'b110:  sign = 1'b1;
            3'b111:  sign = 1'b0;
            default: sign = 1'b0;
        endcase
    end

    always @(*) begin
        case(B)
            3'b000:  gen[width] = 1'b0;
            3'b001:  gen[width] = 1'b0;
            3'b010:  gen[width] = 1'b0;
            3'b011:  gen[width] = A[width-1];
            3'b100:  gen[width] = negA[width-1];
            3'b101:  gen[width] = 1'b1;
            3'b110:  gen[width] = 1'b1;
            3'b111:  gen[width] = 1'b0;
            default: gen[width] = 1'b0;
        endcase
    end

    always @(*) begin
        case(B)
            3'b000:  gen[width-1:0] = 0;
            3'b001:  gen[width-1:0] = A;
            3'b010:  gen[width-1:0] = A;
            3'b011:  gen[width-1:0] = {A[width-2:0],1'b0};
            3'b100:  gen[width-1:0] = {negA[width-2:0],1'b1};
            3'b101:  gen[width-1:0] = negA;
            3'b110:  gen[width-1:0] = negA;
            3'b111:  gen[width-1:0] = 0;
            default: gen[width-1:0] = 0;
        endcase
    end

endmodule