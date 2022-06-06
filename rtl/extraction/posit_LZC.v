module posit_LZC(
    input  [31:0]   in,
    input  [1:0]    mode,
    output [3:0]    cpm1,cpm2,cpm3,cpm4,
    output [4:0]    cph1,cph2,
    output [4:0]    cps
);
wire vpm1,vpm2,vpm3,vpm4,vph1,vph2,vps;
wire [31:0] op;
assign op[30:24] = in[30:24];
assign op[22:16] = in[22:16];
assign op[14:8] = in[14:8];
assign op[6:0] = in[6:0];

assign op[31] = in[30];
assign op[15] = mode[1] ? in[15] : in[14];
assign op[7] = (mode[0] | mode[1]) ? in[7] : in[6];
assign op[23] = (mode[0] | mode[1]) ? in[23] : in[22];


LZC_8bit U0(op[7:0],cpm1,vpm1);
LZC_8bit U1(op[15:8],cpm2,vpm2);
LZC_8bit U2(op[23:16],cpm3,vpm3);
LZC_8bit U3(op[31:24],cpm4,vpm4);

assign vph2 = vpm4 | vpm3;
assign vph1 = vpm2 | vpm1;
assign vps = vph1 | vph2;

assign cph1 = (vpm2&(~(op[7]^op[15]))) ? (cpm1+cpm2) : cpm2;
assign cph2 = (vpm4&(~(op[23]^op[31]))) ? (cpm3+cpm4) : cpm4;
assign cps = (vph2&(~(op[31]^op[15]))) ? (cph1+cph2) : cph2;
endmodule