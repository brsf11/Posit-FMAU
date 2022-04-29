module ModRadix4BoothGen #(
    parameter width = 8
)
(
    input wire[2:0]       B,
    input wire[width-1:0] A,
    output wire[width:0]  gen,
    output wire           sign
);

    wire[width-1:0] negA;

    assign negA = ~A;

    always @(*) begin
        case(B)
            3'b000:  {sign,gen} = '0;
            3'b001:  {sign,gen} = {0,0,A};
            3'b010:  {sign,gen} = {0,0,A};
            3'b011:  {sign,gen} = {0,A,0};
            3'b100:  {sign,gen} = {1,negA,0};
            3'b101:  {sign,gen} = {1,1,negA};
            3'b110:  {sign,gen} = {1,1,negA};
            3'b111:  {sign,gen} = '0;
            default: {sign,gen} = '0;
        endcase
    end

endmodule