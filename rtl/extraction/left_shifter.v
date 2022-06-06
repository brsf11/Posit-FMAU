module left_shifter(
    input [31:0]    in,
    input [1:0]     mode,
    input [3:0]     cpm1,cpm2,cpm3,cpm4,
    input [4:0]     cph1,cph2,
    input [4:0]     cps,
    output [31:0]   out   
);
wire [31:0] op = in;
wire [4:0] shift1,shift2,shift3,shift4;
wire [4:0] temp1,temp2,temp3,temp4;
assign temp1 = mode[0] ? cph1 : cpm1;
assign shift1 = mode[1] ? cps : temp1;
assign temp2 = mode[0] ? cph1 : cpm2;
assign shift2 = mode[1] ? cps : temp2;
assign temp3 = mode[0] ? cph2 : cpm3;
assign shift3 = mode[1] ? cps : temp3;
assign temp4 = mode[0] ? cph2 : cpm4;
assign shift4 = mode[1] ? cps : temp4;
reg [31:0] shift_tmp;
always @(*) begin
    case(mode)
        2'b00:begin
            shift_tmp[7:0] = {in[7:0]} <<     (shift1+1);
            shift_tmp[15:8] = {in[15:8]} <<   (shift2+1);
            shift_tmp[23:16] = {in[23:16]} << (shift3+1);
            shift_tmp[31:24] = {in[31:24]} << (shift4+1);
        end
        2'b01:begin
            shift_tmp[15:0] = {in[15:0]} <<   (shift1+1);
            shift_tmp[31:16] = {in[31:16]} << (shift4+1);
        end
        2'b10:begin
            shift_tmp = in[31:0] << (shift1+1);
        end
    endcase
end
//genvar i;
//generate
//    for(i=1;i<=5;i=i+1) begin
//        always @(*) begin
//        case(mode)
//        2'b00:begin
//            shift_tmp[i][7:0] = shift1[i-1] ? shift_tmp[i-1][7:0] << 2**(i-1) : shift_tmp[i-1][7:0];
//            shift_tmp[i][15:8] = shift2[i-1] ? shift_tmp[i-1][15:8] << 2**(i-1) : shift_tmp[i-1][15:8];
//            shift_tmp[i][23:16] = shift3[i-1] ? shift_tmp[i-1][23:16] << 2**(i-1) : shift_tmp[i-1][23:16];
//            shift_tmp[i][31:24] = shift4[i-1] ? shift_tmp[i-1][31:24] << 2**(i-1) : shift_tmp[i-1][31:24];
//        end
//        2'b01:begin
//            shift_tmp[i][15:0] = shift1[i-1] ? shift_tmp[i-1][15:0] << 2**(i-1) : shift_tmp[i-1][15:0];
//            shift_tmp[i][31:16] = shift3[i-1] ? shift_tmp[i-1][31:16] << 2**(i-1) : shift_tmp[i-1][31:16];
//        end
//        2'b10:begin
//            shift_tmp[i] = shift1[i-1] ? shift_tmp[i-1] << 2**(i-1) : shift_tmp[i-1];
//        end
//        endcase
//        end
//    end
//endgenerate

assign out = shift_tmp;

endmodule