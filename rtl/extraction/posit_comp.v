module posit_comp(
    input  [31:0]   in,
    input  [1:0]    mode,
    output [31:0]   out
    );
wire [31:0] op,op_neg,op_temp;
wire [35:0] op_neg_temp;
assign op = in;   
wire [2:0] t1,x;
wire [3:0] pl,t2,Co;
assign t1[0] = mode[0] ? op[15] : op[7];
assign x[0] = mode[1] ? op[31] : t1[0];
assign t2[0] = mode[0] ? op[15] : op[7];
assign pl[0] = mode[1] ? op[31] : t2[0];
assign op_temp[7:0] = op[7:0] ^ {8{x[0]}};
fulladder_8bit U0(op_neg[7:0],Co[0],op_temp[7:0],8'b0,pl[0]);
//assign op_neg_temp[8:0] = op_temp[7:0] + pl[0];
//assign Co[0] = op_neg_temp[8];
//assign op_neg[7:0] = op_neg_temp[7:0];

assign t1[1] = mode[0] ? op[15] : op[15];
assign x[1] = mode[1] ? op[31] : t1[1];
assign t2[1] = mode[0] ? Co[0] : op[15];
assign pl[1] = mode[1] ? Co[0] : t2[1];
assign op_temp[15:8] = op[15:8] ^ {8{x[1]}};
fulladder_8bit U1(op_neg[15:8],Co[1],op_temp[15:8],8'b0,pl[1]);
//assign op_neg_temp[17:9] = op_temp[15:8] + pl[1];
//assign Co[1] = op_neg_temp[17];
//assign op_neg[15:8] = op_neg_temp[16:9];

assign t1[2] = mode[0] ? op[31] : op[23];
assign x[2] = mode[1] ? op[31] : t1[2];
assign t2[2] = mode[0] ? op[31] : op[23];
assign pl[2] = mode[1] ? Co[1] : t2[2];
assign op_temp[23:16] = op[23:16] ^ {8{x[2]}};
fulladder_8bit U2(op_neg[23:16],Co[2],op_temp[23:16],8'b0,pl[2]);
//assign op_neg_temp[26:18] = op_temp[23:16] + pl[2];
//assign Co[2] = op_neg_temp[26];
//assign op_neg[23:16] = op_neg_temp[25:16];

assign t2[3] = mode[0] ? Co[2] : op[31];
assign pl[3] = mode[1] ? Co[2] : t2[3];
assign op_temp[31:24] = op[31:24] ^ {8{op[31]}};
fulladder_8bit U3(op_neg[31:24],Co[3],op_temp[31:24],8'b0,pl[3]);
//assign op_neg_temp[35:27] = op_temp[31:24] + pl[3];
//assign Co[3] = op_neg_temp[35];
//assign op_neg[31:24] = op_neg_temp[34:27];


assign out = op_neg;
endmodule