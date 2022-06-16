module top(

    input wire  clk,
    input wire  start,
    input wire  [31:0]  A,
    input wire  [31:0]  B,
    input wire  [31:0]  C,
    input wire  [31:0]  D,
    input wire  [1:0]   in_pre,
    input wire  [1:0]   out_pre,
    output reg  [31:0]  out_r,
    output reg  soe
);

wire [3:0] s_A,s_B,s_C,s_D;
wire [15:0] exp_A,exp_B,exp_C,exp_D;
wire [27:0] mant_A,mant_B,mant_C,mant_D;
wire [31:0]  out;

reg start_r;
reg [3:0] s_A_r0,s_B_r0,s_C_r0,s_D_r0;

reg [3:0] s_E_r1,s_F_r1,s_E_r2,s_F_r2;

reg [15:0] exp_A_r,exp_B_r,exp_C_r,exp_D_r;

reg [27:0] mant_A_r,mant_B_r,mant_C_r,mant_D_r;

wire [55:0] mant_E,mant_F;

reg [55:0] mant_E_r1,mant_F_r1,mant_E_r2,mant_F_r2;

wire [67:0] mant_out;

reg [67:0] mant_out_r;

wire [19:0] exp_E,exp_F,exp_out;

reg [19:0] exp_E_r1,exp_F_r1,exp_E_r2,exp_F_r2,exp_out_r;

wire [19:0] exp_ctl;

wire [3:0] swap,s_out;
reg  [3:0] swap_r,s_out_r;

reg [1:0] out_pre1,in_pre1,in_pre2,in_pre3,in_pre4;
reg [31:0] A_r,B_r,C_r,D_r;

wire [3:0]   s_E,s_F,s_E_r,s_F_r,s_E_re,s_F_re;
wire [19:0]  exp_E_re,exp_F_re,exp_E_r,exp_F_r;
wire         align_ctl;
wire [55:0]  mant_E_re,mant_F_re,mant_E_r,mant_F_r;


wire    [13:0]  PP11,PQ11;
wire    [20:7]  PP12,PP21,PQ12,PQ21;
wire    [27:14] PP13,PP22,PP31,PQ13,PQ22,PQ31;
wire    [34:21] PP14,PP23,PP32,PP41,PQ14,PQ23,PQ32,PQ41;
wire    [41:28] PP24,PP33,PP42,PQ24,PQ33,PQ42;
wire    [48:35] PP34,PP43,PQ34,PQ43;
wire    [55:42] PP44,PQ44;

reg    [13:0]  PP11_r,PQ11_r;
reg    [20:7]  PP12_r,PP21_r,PQ12_r,PQ21_r;
reg    [27:14] PP13_r,PP22_r,PP31_r,PQ13_r,PQ22_r,PQ31_r;
reg    [34:21] PP14_r,PP23_r,PP32_r,PP41_r,PQ14_r,PQ23_r,PQ32_r,PQ41_r;
reg    [41:28] PP24_r,PP33_r,PP42_r,PQ24_r,PQ33_r,PQ42_r;
reg    [48:35] PP34_r,PP43_r,PQ34_r,PQ43_r;
reg    [55:42] PP44_r,PQ44_r;

posit_ext extA(A_r,in_pre1,s_A,exp_A,mant_A);

posit_ext extB(B_r,in_pre1,s_B,exp_B,mant_B);

posit_ext extC(C_r,in_pre1,s_C,exp_C,mant_C);

posit_ext extD(D_r,in_pre1,s_D,exp_D,mant_D);

always @(posedge clk) begin
    start_r<=start;
    A_r<=A;
    B_r<=B;
    C_r<=C;
    D_r<=D;
    in_pre1<=in_pre;
    out_pre1<=out_pre;

    
    
    mant_A_r <= mant_A;
    mant_C_r <= mant_C;
    mant_B_r <= mant_B;
    mant_D_r <= mant_D;

    exp_A_r <= exp_A;
    exp_C_r <= exp_C;
    exp_B_r <= exp_B;
    exp_D_r <= exp_D;

    s_A_r0 <= s_A;
    s_B_r0 <= s_B;
    s_C_r0 <= s_C;
    s_D_r0 <= s_D;

    in_pre2<=in_pre1;

    PP11_r <= PP11;
    PP12_r <= PP12;
    PP13_r <= PP13;
    PP14_r <= PP14;
    PP24_r <= PP24;
    PP34_r <= PP34;
    PP44_r <= PP44;
    PQ11_r <= PQ11;
    PP21_r <= PP21;
    PP22_r <= PP22;
    PP23_r <= PP23;
    PP33_r <= PP33;
    PP43_r <= PP43;
    PQ44_r <= PQ44;
    PQ12_r <= PQ12;
    PP31_r <= PP31;
    PP32_r <= PP32;
    PP42_r <= PP42;
    PQ34_r <= PQ34;
    PQ21_r <= PQ21;
    PQ13_r <= PQ13;
    PP41_r <= PP41;
    PQ24_r <= PQ24;
    PQ43_r <= PQ43;
    PQ22_r <= PQ22;
    PQ14_r <= PQ14;
    PQ33_r <= PQ33;
    PQ31_r <= PQ31;
    PQ23_r <= PQ23;
    PQ42_r <= PQ42;
    PQ32_r <= PQ32;
    PQ41_r <= PQ41;
    in_pre3<=in_pre2;



    exp_E_r1 <= exp_E_re;
    exp_F_r1 <= exp_F_re;

    mant_E_r1 <= mant_E_re;
    mant_F_r1 <= mant_F_re;

    s_E_r1 <= s_E;
    s_F_r1 <= s_F;

    exp_E_r2 <= exp_E;
    exp_F_r2 <= exp_F;

    mant_E_r2 <= mant_E;
    mant_F_r2 <= mant_F;

    s_E_r2 <= s_E_re;
    s_F_r2 <= s_F_re;

   
    in_pre4<=in_pre3;
 
    swap_r <= swap;

    s_out_r <= s_out;
   

    exp_out_r <= exp_out;

    mant_out_r <= mant_out;
    

    
    out_r <= out; 

end

assign s_E_r = (align_ctl) ? s_E_r2 : s_E_r1;
assign s_F_r = (align_ctl) ? s_F_r2 : s_F_r1;
assign exp_E_r = (align_ctl) ? exp_E_r1 : exp_E_r2;
assign exp_F_r = (align_ctl) ? exp_F_r1 : exp_F_r2;
assign mant_E_r = (align_ctl) ? mant_E_r1 : mant_E_r2;
assign mant_F_r = (align_ctl) ? mant_F_r1 : mant_F_r2;

exp_adder exp_adder(s_A_r0,s_B_r0,s_C_r0,s_D_r0,exp_A_r,exp_B_r,exp_C_r,exp_D_r,in_pre2,exp_E,exp_F,s_E,s_F);

MatissaMultipleir28x28 MatissaMultipleirU1(mant_A_r,mant_B_r,in_pre2,
    PP11,
    PP12,PP21,
    PP13,PP22,PP31,
    PP14,PP23,PP32,PP41,
    PP24,PP33,PP42,
    PP34,PP43,
    PP44
);
MatissaWallaceTree28x28 MatissaWallaceTree28x28U1(
    PP11_r,
    PP12_r,PP21_r,
    PP13_r,PP22_r,PP31_r,
    PP14_r,PP23_r,PP32_r,PP41_r,
    PP24_r,PP33_r,PP42_r,
    PP34_r,PP43_r,
    PP44_r,
    in_pre3,
    mant_E
);

MatissaMultipleir28x28 MatissaMultipleirU2(mant_C_r,mant_D_r,in_pre2,
    PQ11,
    PQ12,PQ21,
    PQ13,PQ22,PQ31,
    PQ14,PQ23,PQ32,PQ41,
    PQ24,PQ33,PQ42,
    PQ34,PQ43,
    PQ44
);
MatissaWallaceTree28x28 MatissaWallaceTree28x28U2(
    PQ11_r,
    PQ12_r,PQ21_r,
    PQ13_r,PQ22_r,PQ31_r,
    PQ14_r,PQ23_r,PQ32_r,PQ41_r,
    PQ24_r,PQ33_r,PQ42_r,
    PQ34_r,PQ43_r,
    PQ44_r,
    in_pre3,
    mant_F
);

alignment_ctl alignment_ctl(exp_E_r,exp_F_r,in_pre4,exp_ctl,swap);

mant_align mant_align(s_E_r,s_F_r,exp_E_r,exp_F_r,mant_E_r,mant_F_r,exp_ctl,swap,in_pre4,mant_out,exp_out,s_out);

control control(in_pre1,out_pre1,clk,start_r,s_out,mant_out,exp_out,s_E_re,s_F_re,exp_E_re,exp_F_re,align_ctl,mant_E_re,mant_F_re);


packing packing(in_pre4,mant_out_r,exp_out_r,s_out_r,out);

endmodule