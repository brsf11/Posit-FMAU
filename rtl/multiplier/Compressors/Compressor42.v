module Compressor42(input wire  x1,x2,x3,cin,
                    output reg  cout,c,s);

    always @(*) begin
        case({x1,x2,x3,cin})
            4'b0000: {cout,c,s} = 3'b000;
            4'b0001: {cout,c,s} = 3'b001;
            4'b0010: {cout,c,s} = 3'b001;
            4'b0011: {cout,c,s} = 3'b010;
            4'b0100: {cout,c,s} = 3'b001;
            4'b0101: {cout,c,s} = 3'b010;
            4'b0110: {cout,c,s} = 3'b010;
            4'b0111: {cout,c,s} = 3'b011;
            4'b1000: {cout,c,s} = 3'b001;
            4'b1001: {cout,c,s} = 3'b010;
            4'b1010: {cout,c,s} = 3'b010;
            4'b1011: {cout,c,s} = 3'b011;
            4'b1100: {cout,c,s} = 3'b010;
            4'b1101: {cout,c,s} = 3'b011;
            4'b1110: {cout,c,s} = 3'b011;
            4'b1111: {cout,c,s} = 3'b110;
            default: {cout,c,s} = 3'b000;
        endcase
    end

endmodule