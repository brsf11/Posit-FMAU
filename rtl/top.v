module top(

    input wire  clk,
    input wire  [31:0]  A,
    input wire  [31:0]  B,
    input wire  [31:0]  C,
    input wire  [31:0]  D,
    input wire  [1:0]   in_pre,
    input wire  [1:0]   out_pre,
    output reg [31:0]  out_r
);


wire [3:0] s_A,s_B,s_C,s_D;
wire [15:0] exp_A,exp_B,exp_C,exp_D;
wire [27:0] mant_A,mant_B,mant_C,mant_D;
wire [31:0]  out;

reg [3:0] s_A_r0,s_B_r0,s_C_r0,s_D_r0;

reg [3:0] s_A_r1,s_B_r1,s_C_r1,s_D_r1;

reg [3:0] s_A_r2,s_B_r2,s_C_r2,s_D_r2;

reg [15:0] exp_A_r,exp_B_r,exp_C_r,exp_D_r;

reg [27:0] mant_A_r,mant_B_r,mant_C_r,mant_D_r;

wire [55:0] mant_E,mant_F;

reg [55:0] mant_E_r,mant_F_r;

wire [67:0] mant_out;

reg [67:0] mant_out_r;

wire [19:0] exp_E,exp_F;

reg [19:0] exp_E_r,exp_F_r;

wire [19:0] exp_ctl;

wire [3:0] swap;


posit_ext extA(A,in_pre,s_A,exp_A,mant_A);



posit_ext extB(B,in_pre,s_B,exp_B,mant_B);



posit_ext extC(C,in_pre,s_C,exp_C,mant_C);



posit_ext extD(D,in_pre,s_D,exp_D,mant_D);



always @(posedge clk) begin



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



    s_A_r1 <= s_A_r0;

    s_B_r1 <= s_B_r0;

    s_C_r1 <= s_C_r0;

    s_D_r1 <= s_D_r0;



    s_A_r2 <= s_A_r1;

    s_B_r2 <= s_B_r1;

    s_C_r2 <= s_C_r1;

    s_D_r2 <= s_D_r1;


    exp_E_r <= exp_E;

    exp_F_r <= exp_F;

    mant_E_r <= mant_E;

    mant_F_r <= mant_F;

    mant_out_r <= mant_out;
    out_r <= out; 

end


exp_adder exp_adder(exp_A_r,exp_B_r,exp_C_r,exp_D_r,in_pre,exp_E,exp_F);

MatissaMultipleir28x28 MatissaMultipleirU1(mant_A_r,mant_B_r,in_pre,mant_E);

MatissaMultipleir28x28 MatissaMultipleirU2(mant_C_r,mant_D_r,in_pre,mant_F);

alignment_ctl alignment_ctl(exp_E_r,exp_F_r,in_pre,exp_ctl,swap);

mant_align mant_align(mant_E_r,mant_F_r,exp_ctl,swap,in_pre,mant_out);

packing packing(in_pre,mant_out_r,swap,exp_E_r,exp_F_r,s_A_r2,s_B_r2,s_C_r2,s_D_r2,out);

endmodule