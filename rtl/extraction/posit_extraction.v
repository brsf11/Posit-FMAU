module posit_ext(

    input   wire [31:0] in,
    input   wire [1:0]  mode,
    output  wire [3:0]  s,
    output  wire [15:0] rg_exp,
    output  wire [27:0] mant
);
assign s[0]  = in[7];
assign s[1] = in[15];
assign s[2] = in[23];
assign s[3] = in[31];
wire [31:0] op_neg,exp_mant;
posit_comp U0(in,mode,op_neg);
wire [3:0]  cpm1;
wire [3:0]  cpm2;
wire [3:0]  cpm3;
wire [3:0]  cpm4;
wire [4:0]  cph1;
wire [4:0]  cph2;
wire [4:0]  cps ;
posit_LZC U1(op_neg,mode,cpm1,cpm2,cpm3,cpm4,cph1,cph2,cps);
left_shifter U2(op_neg,mode,cpm1,cpm2,cpm3,cpm4,cph1,cph2,cps,exp_mant);
reg [27:0] mant_tmp;
assign mant = mant_tmp;
reg [15:0] rg_exp_tmp;
assign rg_exp = rg_exp_tmp;
always @(*) begin
    case(mode)
        2'b00:begin
            mant_tmp[6:0] = {1'b1,exp_mant[7:2]};
            mant_tmp[13:7] = {1'b1,exp_mant[15:10]};
            mant_tmp[20:14] = {1'b1,exp_mant[23:18]};
            mant_tmp[27:21] = {1'b1,exp_mant[31:26]};
            rg_exp_tmp[3:0] = op_neg[6] ? (cpm1-2) : (-cpm1+1);
            rg_exp_tmp[7:4] = op_neg[14] ? (cpm2-2) : (-cpm2+1);
            rg_exp_tmp[11:8] = op_neg[22] ? (cpm3-2) : (-cpm3+1);
            rg_exp_tmp[15:12] = op_neg[30] ? (cpm4-2) : (-cpm4+1);
        end
        2'b01:begin
            mant_tmp[27:14] = {1'b1,exp_mant[30:18]};
            mant_tmp[13:0] = {1'b1,exp_mant[14:2]};
            rg_exp_tmp[7:0] = op_neg[14] ? {2'b0,(cph1-2),exp_mant[15]} : {2'b0,(-cph1+1),exp_mant[15]};
            rg_exp_tmp[15:8] = op_neg[30] ? {2'b0,(cph2-2),exp_mant[31]} : {2'b0,(-cph2+1),exp_mant[31]};
        end
        2'b10:begin
            mant_tmp = {1'b1,exp_mant[29:2]};
            rg_exp_tmp = op_neg[30] ? {9'b0,(cps-2),exp_mant[31:30]} : {9'b0,(-cps+1),exp_mant[31:30]} ;
        end
        default:begin
            mant_tmp=0;
            rg_exp_tmp=0;
        end

    endcase
end

endmodule