module Compressor32(input wire  x1,x2,x3,
                    output reg  s,c);

    always @(*) begin
        case({x1,x2,x3})
            3'b000:  {c,s} = 2'b00;
            3'b001:  {c,s} = 2'b01;
            3'b010:  {c,s} = 2'b01;
            3'b011:  {c,s} = 2'b10;
            3'b100:  {c,s} = 2'b01;
            3'b101:  {c,s} = 2'b10;
            3'b110:  {c,s} = 2'b10;
            3'b111:  {c,s} = 2'b11;
            default: {c,s} = 2'b00;
        endcase
    end

endmodule