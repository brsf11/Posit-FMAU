module control(
    input   wire    [1:0]   in_pre,
    input   wire    [1:0]   out_pre,
    input   wire            clk,
    input   wire            start,
    
    input   wire    [3:0]   s,
    input   wire    [67:0]  mant,
    input   wire    [19:0]  exp,

    output  reg     [3:0]   s_E,s_F,
    output  reg     [19:0]  exp_E,exp_F,
    output  reg             align_ctl,
    output  reg     [55:0]  mant_E,mant_F

);

reg [2:0] period;
reg [1:0] pre,pre_r;
reg [1:0] out;
always@(posedge clk) begin
    if(start) begin
        period <= 3'b0;
        pre_r <= in_pre;
        out <= out_pre;
    end
    else begin
        period <= period + 1;
        pre_r<=pre;
        out <= out;
    end

end
always@(*) begin
    if((period>3)&(pre_r<out)) begin
        case(pre_r)
            2'b00:begin
                s_E[0] = s[0];
                s_E[2] = s[1];
                s_F[0] = s[2];
                s_F[2] = s[3];
                exp_E[9:0] = exp[4:0];
                exp_E[19:10] = exp[9:5];
                exp_F[9:0] = exp[14:10];
                exp_F[19:10] = exp[19:15];
                mant_E[27:0] = mant[16:0];
                mant_E[55:28] = mant[33:17];
                mant_F[27:0] = mant[50:34];
                mant_F[55:28] = mant[67:51];
                align_ctl = 1;
                pre = 2'b01;
            end
            2'b01:begin
                s_E[3] = s[1];
                s_F[3] = s[3];
                exp_E[19:0] = exp[9:0];
                exp_F[19:0] = exp[19:10];
                mant_E[55:0] = mant[33:0];
                mant_F[55:0] = mant[67:34];
                align_ctl = 1;
                pre = 2'b10;
            end
            default:begin
                s_E[0] = s[0];
                s_E[2] = s[1];
                s_F[0] = s[2];
                s_F[2] = s[3];
                exp_E[9:0] = exp[4:0];
                exp_E[19:10] = exp[9:5];
                exp_F[9:0] = exp[14:10];
                exp_F[19:10] = exp[19:15];
                mant_E[27:0] = mant[16:0];
                mant_E[55:28] = mant[33:17];
                mant_F[27:0] = mant[50:34];
                mant_F[55:28] = mant[67:51];
                align_ctl = 1;
                pre = 2'b01;
            end
        endcase

    end
    else begin
        s_E=0;
        s_F=0;
        exp_E=0;
        exp_F=0;
        mant_E=0;
        mant_F=0;
        align_ctl = 0;
        pre = pre_r;
    end
 end

                
             

    
    
endmodule