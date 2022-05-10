module Compressor42(input wire  x1,x2,x3,x4,cin,
                    output reg  cout,c,s);

    always @(*) begin
        case({x1,x2,x3,x4,cin})
            5'b00000: {cout,c,s} = 3'b000;
            5'b00001: {cout,c,s} = 3'b001;
            5'b00010: {cout,c,s} = 3'b001;
            5'b00011: {cout,c,s} = 3'b010;
            5'b00100: {cout,c,s} = 3'b001;
            5'b00101: {cout,c,s} = 3'b010;
            5'b00110: {cout,c,s} = 3'b010;
            5'b00111: {cout,c,s} = 3'b011;
            5'b01000: {cout,c,s} = 3'b001;
            5'b01001: {cout,c,s} = 3'b010;
            5'b01010: {cout,c,s} = 3'b010;
            5'b01011: {cout,c,s} = 3'b011;
            5'b01100: {cout,c,s} = 3'b010;
            5'b01101: {cout,c,s} = 3'b011;
            5'b01110: {cout,c,s} = 3'b011;
            5'b01111: {cout,c,s} = 3'b110;
            5'b10000: {cout,c,s} = 3'b001;
            5'b10001: {cout,c,s} = 3'b010;
            5'b10010: {cout,c,s} = 3'b010;
            5'b10011: {cout,c,s} = 3'b011;
            5'b10100: {cout,c,s} = 3'b010;
            5'b10101: {cout,c,s} = 3'b011;
            5'b10110: {cout,c,s} = 3'b011;
            5'b10111: {cout,c,s} = 3'b110;
            5'b11000: {cout,c,s} = 3'b010;
            5'b11001: {cout,c,s} = 3'b011;
            5'b11010: {cout,c,s} = 3'b011;
            5'b11011: {cout,c,s} = 3'b110;
            5'b11100: {cout,c,s} = 3'b011;
            5'b11101: {cout,c,s} = 3'b110;
            5'b11110: {cout,c,s} = 3'b110;
            5'b11111: {cout,c,s} = 3'b111;
            default:  {cout,c,s} = 3'b000;
        endcase
    end

endmodule