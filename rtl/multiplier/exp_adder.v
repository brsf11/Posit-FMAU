module exp_adder(
    input   wire    [15:0]  exp_A,
    input   wire    [15:0]  exp_B,
    input   wire    [15:0]  exp_C,
    input   wire    [15:0]  exp_D,
    input   wire    [1:0]   mode,
    output  wire    [19:0]  exp_E,
    output  wire    [19:0]  exp_F
);
reg [19:0] reg_exp_E1,reg_exp_F1;

always@(*) begin
    case(mode)
        2'b00:begin
            reg_exp_E1[4:0] =   {exp_A[3], exp_A[3:0]  } + {exp_B[3], exp_B[3:0]  };
            reg_exp_E1[9:5] =   {exp_A[7], exp_A[7:4]  } + {exp_B[7], exp_B[7:4]  };
            reg_exp_E1[14:10] = {exp_A[11],exp_A[11:8] } + {exp_B[11],exp_B[11:8] };
            reg_exp_E1[19:15] = {exp_A[15],exp_A[15:12]} + {exp_B[15],exp_B[15:12]};
            reg_exp_F1[4:0] =   {exp_C[3], exp_C[3:0]  } + {exp_D[3], exp_D[3:0]  };
            reg_exp_F1[9:5] =   {exp_C[7], exp_C[7:4]  } + {exp_D[7], exp_D[7:4]  };
            reg_exp_F1[14:10] = {exp_C[11],exp_C[11:8] } + {exp_D[11],exp_D[11:8] };
            reg_exp_F1[19:15] = {exp_C[15],exp_C[15:12]} + {exp_D[15],exp_D[15:12]};
        end
        2'b01:begin
            reg_exp_E1[9:0] =   {exp_A[7] ,exp_A[7:0] } + {exp_B[7] ,exp_B[7:0] };
            reg_exp_E1[19:10] = {exp_A[15],exp_A[15:8]} + {exp_B[15],exp_B[15:8]};
            reg_exp_F1[9:0] =   {exp_C[7] ,exp_C[7:0] } + {exp_D[7] ,exp_D[7:0] };
            reg_exp_F1[19:10] = {exp_C[15],exp_C[15:8]} + {exp_D[15],exp_D[15:8]};
        end
        2'b10:begin
            reg_exp_E1[19:0] = {exp_A[15],exp_A[15:0]} + {exp_B[15],exp_B[15:0]};
            reg_exp_F1[19:0] = {exp_C[15],exp_C[15:0]} + {exp_D[15],exp_D[15:0]};
        end
        default:begin
            reg_exp_E1[19:0] = {exp_A[15],exp_A[15:0]} + {exp_B[15],exp_B[15:0]};
            reg_exp_F1[19:0] = {exp_C[15],exp_C[15:0]} + {exp_D[15],exp_D[15:0]};
        end
    endcase
end

assign exp_E = reg_exp_E1;
assign exp_F = reg_exp_F1;


endmodule
