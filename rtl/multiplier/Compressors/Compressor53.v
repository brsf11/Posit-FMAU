module Compressor53(input wire  x1,x2,x3,x4,x5,
                    output reg  c2,c1,s);

    always @(*) begin
        case({x1,x2,x3,x4,x5})
            5'b00000: {c2,c1,s} = 3'b000;
            5'b00001: {c2,c1,s} = 3'b001;
            5'b00010: {c2,c1,s} = 3'b001;
            5'b00011: {c2,c1,s} = 3'b010;
            5'b00100: {c2,c1,s} = 3'b001;
            5'b00101: {c2,c1,s} = 3'b010;
            5'b00110: {c2,c1,s} = 3'b010;
            5'b00111: {c2,c1,s} = 3'b011;
            5'b01000: {c2,c1,s} = 3'b001;
            5'b01001: {c2,c1,s} = 3'b010;
            5'b01010: {c2,c1,s} = 3'b010;
            5'b01011: {c2,c1,s} = 3'b011;
            5'b01100: {c2,c1,s} = 3'b010;
            5'b01101: {c2,c1,s} = 3'b011;
            5'b01110: {c2,c1,s} = 3'b011;
            5'b01111: {c2,c1,s} = 3'b100;
            5'b10000: {c2,c1,s} = 3'b001;
            5'b10001: {c2,c1,s} = 3'b010;
            5'b10010: {c2,c1,s} = 3'b010;
            5'b10011: {c2,c1,s} = 3'b011;
            5'b10100: {c2,c1,s} = 3'b010;
            5'b10101: {c2,c1,s} = 3'b011;
            5'b10110: {c2,c1,s} = 3'b011;
            5'b10111: {c2,c1,s} = 3'b100;
            5'b11000: {c2,c1,s} = 3'b010;
            5'b11001: {c2,c1,s} = 3'b011;
            5'b11010: {c2,c1,s} = 3'b011;
            5'b11011: {c2,c1,s} = 3'b100;
            5'b11100: {c2,c1,s} = 3'b011;
            5'b11101: {c2,c1,s} = 3'b100;
            5'b11110: {c2,c1,s} = 3'b100;
            5'b11111: {c2,c1,s} = 3'b101;
            default:  {c2,c1,s} = 3'b000;
        endcase
    end

endmodule