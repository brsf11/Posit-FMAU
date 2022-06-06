module LZC_8bit(
    input [7:0] in,
    output [3:0] out,
    output vector
);

reg [7:0] lzd_cnt1;
reg [4:0] lzd_cnt2 [7:0];
wire [7:0] op;
assign op = in[7] ? (~in) : in;
genvar i ;
generate
    for(i=0;i<=7;i=i+1) begin
        always@(*) begin
            lzd_cnt1[i] = (op[7:7-i]==1'b0) ? 1'b1 : 1'b0;
            lzd_cnt2[i] = (i==0) ? lzd_cnt1[i] : lzd_cnt1[i] + lzd_cnt2[i-1];
        end
    end
endgenerate
assign vector = (lzd_cnt2[7]==5'd8) ? 1'b1 : 1'b0;
assign out = lzd_cnt2[7];
endmodule