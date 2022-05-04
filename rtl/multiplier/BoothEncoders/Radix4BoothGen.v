module Radix4BoothGen #(
    parameter width = 8
)
(
    input wire[2:0]       B,
    input wire[width-1:0] A,
    output reg[width:0]   gen
);

    wire[width-1:0] negA;

    assign negA = ~A + 1'b1;

    always @(*) begin
        case(B)
            3'b000:  {gen} = 0;
            3'b001:  {gen} = {0,A};
            3'b010:  {gen} = {0,A};
            3'b011:  {gen} = {A,0};
            3'b100:  {gen} = {negA,0};
            3'b101:  {gen} = {1,negA};
            3'b110:  {gen} = {1,negA};
            3'b111:  {gen} = 0;
            default: {gen} = 0;
        endcase
    end

endmodule