module top(
    input wire  clk,
    input wire  [31:0]  A,
    input wire  [31:0]  B,
    input wire  [31:0]  C,
    input wire  [31:0]  D,
    input wire  [1:0]   in_pre,
    input wire  [1:0]   out_pre,
    output wire [31:0]  out
       
);

wire [3:0] s_A,s_B,s_C,s_D;
wire [15:0] exp_A,exp_B,exp_C,exp_D;
wire [27:0] mant_A,mant_B,mant_C,mant_D;
posit_ext extA(clk,A,in_pre,s_A,exp_A,mant_A);
posit_ext extB(clk,B,in_pre,s_B,exp_B,mant_B);
posit_ext extC(clk,C,in_pre,s_C,exp_C,mant_C);
posit_ext extD(clk,D,in_pre,s_D,exp_D,mant_D);




wire [55:0] mant_E,mant_F;
wire [67:0] mant_out;
wire [19:0] exp_E,exp_F;
exp_adder exp_adder(exp_A,exp_B,exp_C,exp_D,in_pre,exp_E,exp_F);
wire [19:0] exp_ctl;
wire [3:0] swap;
alignment_ctl alignment_ctl(exp_E,exp_F,in_pre,exp_ctl,swap);
MatissaMultipleir28x28 MatissaMultipleirU1(clk,mant_A,mant_B,in_pre,mant_E);
MatissaMultipleir28x28 MatissaMultipleirU2(clk,mant_C,mant_D,in_pre,mant_F);
mant_align mant_align(clk,mant_E,mant_F,exp_ctl,swap,in_pre,mant_out);
packing packing(clk,in_pre,mant_out,swap,exp_E,exp_F,s_A,s_B,s_C,s_D,out);

endmodule