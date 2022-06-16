module mant_align(
    input   wire    [3:0]   s_E,s_F,
    input   wire    [19:0]  exp_E,
    input   wire    [19:0]  exp_F,
    input   wire    [55:0]  mant_E,
    input   wire    [55:0]  mant_F,
    input   wire    [19:0]  ctl,
    input   wire    [3:0]   swap,
    input   wire    [1:0]   in_pre,

    output  reg    [67:0]  mant_pl_r,
    output  reg    [19:0]  exp,
    output  reg    [3:0]   s
);
reg [127:0] mant_big,mant_small,mant_small_al;
reg [67:0] mant_big_sign,mant_small_sign;
reg    [67:0]  mant_pl_sign,mant_pl;
wire [3:0] lzc1,lzc2,lzc3,lzc4;
wire v1,v2,v3,v4;
LZC_8bit U0({1'b0,mant_pl[16:10]},lzc1,v1);
LZC_8bit U1({1'b0,mant_pl[33:27]},lzc2,v2);
LZC_8bit U2({1'b0,mant_pl[50:44]},lzc3,v3);
LZC_8bit U3({1'b0,mant_pl[67:61]},lzc4,v4);
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


            if(swap[0]) begin
                mant_big_sign[16:0] = s_F[0] ? (-{2'b0,mant_big[31:17]}):({2'b0,mant_big[31:17]});
                mant_small_sign[16:0] = s_E[0] ? (-{2'b0,mant_small_al[31:17]}):({2'b0,mant_small_al[31:17]});
            end
            else begin
                mant_big_sign[16:0] = s_E[0] ? (-{2'b0,mant_big[31:17]}):({2'b0,mant_big[31:17]});
                mant_small_sign[16:0] = s_F[0] ? (-{2'b0,mant_small_al[31:17]}):({2'b0,mant_small_al[31:17]});
            end
            if(swap[1]) begin
                mant_big_sign[33:17] = s_F[1] ? (-{2'b0,mant_big[63:49]}):({2'b0,mant_big[63:49]});
                mant_small_sign[33:17] = s_E[1] ? (-{2'b0,mant_small_al[63:49]}):({2'b0,mant_small_al[63:49]});
            end
            else begin
                mant_big_sign[33:17] = s_E[1] ? (-{2'b0,mant_big[63:49]}):({2'b0,mant_big[63:49]});
                mant_small_sign[33:17] = s_F[1] ? (-{2'b0,mant_small_al[63:49]}):({2'b0,mant_small_al[63:49]});
            end
            if(swap[2]) begin
                mant_big_sign[50:34] = s_F[2] ? (-{2'b0,mant_big[95:81]}):({2'b0,mant_big[95:81]});
                mant_small_sign[50:34] = s_E[2] ? (-{2'b0,mant_small_al[95:81]}):({2'b0,mant_small_al[95:81]});
            end
            else begin
                mant_big_sign[50:34] = s_E[2] ? (-{2'b0,mant_big[95:81]}):({2'b0,mant_big[95:81]});
                mant_small_sign[50:34] = s_F[2] ? (-{2'b0,mant_small_al[95:81]}):({2'b0,mant_small_al[95:81]});
            end
            if(swap[3]) begin
                mant_big_sign[67:51] = s_F[3] ? (-{2'b0,mant_big[127:113]}):({2'b0,mant_big[127:113]});
                mant_small_sign[67:51] = s_E[3] ? (-{2'b0,mant_small_al[127:113]}):({2'b0,mant_small_al[127:113]});
            end
            else begin
                mant_big_sign[67:51] = s_E[3] ? (-{2'b0,mant_big[31:17]}):({2'b0,mant_big[31:17]});
                mant_small_sign[67:51] = s_F[3] ? (-{2'b0,mant_small_al[127:113]}):({2'b0,mant_small_al[127:113]});
            end


            mant_pl_sign[16:0] = mant_big_sign[16:0] + mant_small_sign[16:0];
            mant_pl_sign[33:17] = mant_big_sign[33:17] + mant_small_sign[33:17];
            mant_pl_sign[50:34] = mant_big_sign[50:34] + mant_small_sign[50:34];
            mant_pl_sign[67:51] = mant_big_sign[67:51] + mant_small_sign[67:51];

            
            s[0]=mant_pl_sign[16];
            s[1]=mant_pl_sign[33];
            s[2]=mant_pl_sign[50];
            s[3]=mant_pl_sign[67];

            mant_pl[16:0]  = s[0] ? ({-mant_pl_sign[15:0],1'b0}): {mant_pl_sign[15:0],1'b0};
            mant_pl[33:17] = s[1] ? ({-mant_pl_sign[32:17],1'b0}):{mant_pl_sign[32:17],1'b0};
            mant_pl[50:34] = s[2] ? ({-mant_pl_sign[49:34],1'b0}):{mant_pl_sign[49:34],1'b0};
            mant_pl[67:51] = s[3] ? ({-mant_pl_sign[66:51],1'b0}):{mant_pl_sign[66:51],1'b0};

            mant_pl_r[16:0]  = mant_pl[16:0]  << (lzc1);
            mant_pl_r[33:17] = mant_pl[33:17] << (lzc2);
            mant_pl_r[50:34] = mant_pl[50:34] << (lzc3);
            mant_pl_r[67:51] = mant_pl[67:51] << (lzc4);
            
            exp[4:0] = swap[0] ? (exp_F[4:0] + 3 - lzc1) : (exp_E[4:0]  + 3 - lzc1);
            exp[9:5] = swap[1] ? (exp_F[9:5] + 3 - lzc2) : (exp_E[9:5]  + 3 - lzc2);
            exp[14:10] = swap[2] ? (exp_F[14:10] + 3 - lzc3) : (exp_E[14:10] + 3- lzc3);
            exp[19:15] = swap[3] ? (exp_F[19:15] + 3 - lzc4) : (exp_E[19:15] + 3 - lzc4);
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

            exp[9:0] = swap[1] ? (exp_F[9:0] + mant_pl[33] + 1) : (exp_E[9:0] + mant_pl[33] + 1);
            exp[19:10] = swap[3] ? (exp_F[19:10] + mant_pl[67] + 1) : (exp_E[19:10] + mant_pl[67] + 1);

        end
        2'b10:begin
            mant_big[127:0] = swap[3] ? {12'b0,mant_F[55:0],60'b0} : {12'b0,mant_E[55:0],60'b0};
            mant_small[127:0] = swap[3] ? {70'b0,mant_E[55:0],2'b0} : {12'b0,mant_F[55:0],60'b0};
            
            mant_small_al[127:0] = mant_small[127:0] << ctl[19:0];
            mant_pl = mant_big[115:59] + mant_small_al[115:59];
            exp[19:0] = swap[3] ? (exp_F[19:0] + mant_pl[67] + 1) : (exp_E[19:0] + mant_pl[67] + 1);
        end
        default:begin
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

            exp[4:0] = swap[0] ? (exp_F[4:0] + mant_pl[16] +1) : (exp_E[4:0] + mant_pl[16] + 1);
            exp[9:5] = swap[1] ? (exp_F[9:5] + mant_pl[33] + 1) : (exp_E[9:5] + mant_pl[33] + 1);
            exp[14:10] = swap[2] ? (exp_F[14:10] + mant_pl[50] + 1) : (exp_E[14:10] + mant_pl[50] + 1);
            exp[19:15] = swap[3] ? (exp_F[19:15] + mant_pl[67] + 1) : (exp_E[19:15] + mant_pl[67] + 1);
        end
    endcase
end

endmodule