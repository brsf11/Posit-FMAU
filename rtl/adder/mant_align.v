module mant_align(

    input   wire    [55:0]  mant_E,
    input   wire    [55:0]  mant_F,
    input   wire    [19:0]  ctl,
    input   wire    [3:0]   swap,
    input   wire    [1:0]   in_pre,

    output  reg    [67:0]  mant_pl
);
reg [127:0] mant_big,mant_small,mant_small_al;
always@(*) begin
    case(in_pre)
        2'b00:begin 
            mant_big[31:0] = swap[0] ? {mant_F[13:0],18'b0} : {mant_E[13:0],18'b0};
            mant_big[63:32] = swap[1] ? {mant_F[27:14],18'b0} : {mant_E[27:14],18'b0};
            mant_big[95:64] = swap[2] ? {mant_F[41:28],18'b0} : {mant_E[41:28],18'b0};
            mant_big[127:96] = swap[3] ? {mant_F[55:42],18'b0} : {mant_E[55:42],18'b0};

            mant_small[31:0] = swap[0] ? {16'b0,mant_E[13:0],2'b0} : {16'b0,mant_F[13:0],2'b0};
            mant_small[63:32] = swap[1] ? {16'b0,mant_E[27:14],2'b0} : {16'b0,mant_F[27:14],2'b0};
            mant_small[95:64] = swap[2] ? {16'b0,mant_E[41:28],2'b0} : {16'b0,mant_F[41:28],2'b0};
            mant_small[127:96] = swap[3] ? {16'b0,mant_E[55:42],2'b0} : {16'b0,mant_F[55:42],2'b0};

            mant_small_al[31:0]  = mant_small[31:0] << ctl[4:0];
            mant_small_al[63:32] = mant_small[63:32] << ctl[9:5];
            mant_small_al[95:64] = mant_small[95:64] << ctl[14:10];
            mant_small_al[127:96]= mant_small[127:96]<< ctl[19:15];

            mant_pl[16:0] = mant_big[31:16] + mant_small_al[31:16];
            mant_pl[33:17] = mant_big[63:48] + mant_small_al[63:48];
            mant_pl[50:34] = mant_big[95:80] + mant_small_al[95:80];
            mant_pl[67:51] = mant_big[127:112] + mant_small_al[127:112];
        end
        2'b01:begin
            mant_big[63:0] = swap[1] ? {4'b0,mant_F[27:0],32'b0} : {4'b0,mant_E[27:0],32'b0};
            mant_big[127:64] = swap[3] ? {4'b0,mant_F[55:42],32'b0} : {4'b0,mant_E[55:42],18'b0};
            mant_small[63:0] = swap[1] ? {34'b0,mant_E[27:0],2'b0} : {34'b0,mant_F[27:0],2'b0};
            mant_small[127:64] = swap[3] ? {34'b0,mant_E[55:28],2'b0} : {34'b0,mant_F[55:28],2'b0};

            mant_small_al[63:0] = mant_small[63:0] << ctl[9:0];
            mant_small_al[127:64] = mant_small[127:64] << ctl[19:10];

            mant_pl[33:0] = mant_big[59:30] + mant_small_al[59:30];
            mant_pl[67:34] = mant_big[123:94] + mant_small_al[123:94];
        end
        2'b10:begin
            mant_big[127:0] = swap[3] ? {12'b0,mant_F[55:0],60'b0} : {12'b0,mant_E[55:0],60'b0};
            mant_small[127:0] = swap[3] ? {70'b0,mant_E[55:0],2'b0} : {12'b0,mant_F[55:0],60'b0};
            
            mant_small_al[127:0] = mant_small[127:0] << ctl[19:0];
            mant_pl = mant_big[115:59] + mant_small_al[115:59];
        end
        default:begin
            mant_big[127:0] = swap[3] ? {12'b0,mant_F[55:0],60'b0} : {12'b0,mant_E[55:0],60'b0};
            mant_small[127:0] = swap[3] ? {70'b0,mant_E[55:0],2'b0} : {12'b0,mant_F[55:0],60'b0};
            
            mant_small_al[127:0] = mant_small[127:0] << ctl[19:0];
            mant_pl = mant_big[115:59] + mant_small_al[115:59];
        end
    endcase
end

endmodule