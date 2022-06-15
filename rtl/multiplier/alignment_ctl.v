module alignment_ctl(
    input   wire    [19:0]  exp_E,
    input   wire    [19:0]  exp_F,
    input   wire    [1:0]   in_pre,
    output  wire     [19:0]  ctl,
    output  reg     [3:0]   swap
);
reg [19:0] exp_align,exp_align_ctl;


assign ctl = exp_align_ctl;

always@(*) begin
    case(in_pre)
        2'b00:begin
            exp_align[4:0] = exp_E[4:0] - exp_F[4:0];
            exp_align[9:5] = exp_E[9:5] - exp_F[9:5];
            exp_align[14:10] = exp_E[14:10] - exp_F[14:10];
            exp_align[19:15] = exp_E[19:15] - exp_F[19:15];
            if (exp_align[4]) begin
                swap[0] = 1'b1;
                exp_align_ctl[4:0] = 5'd16 + exp_align[4:0];
            end
            else begin
                swap[0] = 1'b0;
                exp_align_ctl[4:0] = 5'd16 - exp_align[4:0];
            end

            if (exp_align[9]) begin
                swap[1] = 1'b1;
                exp_align_ctl[9:5] = 5'd16 + exp_align[9:5];
            end
            else begin
                swap[1] = 1'b0;
                exp_align_ctl[9:5] = 5'd16 - exp_align[9:5];
            end

            if (exp_align[14]) begin
                swap[2] = 1'b1;
                exp_align_ctl[14:10] = 5'd16 + exp_align[14:10];
            end
            else begin
                swap[2] = 1'b0;
                exp_align_ctl[14:10] = 5'd16 - exp_align[14:10];
            end

            if (exp_align[19]) begin
                swap[3] = 1'b1;
                exp_align_ctl[19:15] = 5'd16 + exp_align[19:15];
            end
            else begin
                swap[3] = 1'b0;
                exp_align_ctl[19:15] = 5'd16 - exp_align[19:15];
            end

        end
        2'b01:begin
            exp_align[9:0] = exp_E[7:0] + exp_F[7:0];
            exp_align[19:10] = exp_E[15:8] + exp_F[15:8];
            if (exp_align[9]) begin
                swap[1] = 1'b1;
                exp_align_ctl[9:0] = 5'd30 + exp_align[9:0];
            end
            else begin
                swap[1] = 1'b0;
                exp_align_ctl[9:0] = 5'd30 - exp_align[9:0];
            end

            if (exp_align[19]) begin
                swap[3] = 1'b1;
                exp_align_ctl[19:10] = 5'd30 + exp_align[19:10];
            end
            else begin
                swap[3] = 1'b0;
                exp_align_ctl[19:10] = 5'd30 - exp_align[19:10];
            end
        end
        2'b10:begin
            exp_align[19:0] = exp_E[15:0] + exp_F[15:0];
            exp_align[19:0] = exp_E[15:0] + exp_F[15:0];
            if (exp_align[19]) begin
                swap[3] = 1'b1;
                exp_align_ctl[19:0] = 6'd58 + exp_align[19:0];
            end
            else begin
                swap[3] = 1'b0;
                exp_align_ctl[19:0] = 6'd58 - exp_align[19:0];
            end
        end
        default:begin
            exp_align[19:0] = exp_E[15:0] + exp_F[15:0];
            exp_align[19:0] = exp_E[15:0] + exp_F[15:0];
            if (exp_align[19]) begin
                swap[3] = 1'b1;
                exp_align_ctl[19:0] = 6'd58 + exp_align[19:0];
            end
            else begin
                swap[3] = 1'b0;
                exp_align_ctl[19:0] = 6'd58 - exp_align[19:0];
            end
        end
    endcase   
end
endmodule