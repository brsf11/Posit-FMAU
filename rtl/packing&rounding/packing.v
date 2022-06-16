module packing(

    input   wire    [1:0]   in_pre,
    input   wire    [67:0]  mant,
    input   wire    [19:0]  exp,
    input   wire    [3:0]   s,
    output  reg    [31:0]  out_r
);

reg [19:0] regime;
reg [19:0] REM1,REM2,REM3,REM4;
reg [36:0] REM5,REM6;
reg [69:0] REM7;
reg    [31:0]  out;
reg [3:0] L1,G1,R1,St1,ulp1;
reg [6:0] rnd_ulp_REM1,rnd_ulp_REM2,rnd_ulp_REM3,rnd_ulp_REM4;
reg [6:0] ulp_REM1,ulp_REM2,ulp_REM3,ulp_REM4;
reg [14:0] ulp_REM5,ulp_REM6,rnd_ulp_REM5,rnd_ulp_REM6;
reg [30:0] ulp_REM7,rnd_ulp_REM7;


always@(*) begin
    case(in_pre)
        2'b00:begin
                     
            regime[4:0] = exp[4] ? (-exp[4:0]) : (exp[4:0]+1);
            regime[9:5] = exp[9] ? (-exp[9:5]) : (exp[9:5]+1);
            regime[14:10] = exp[14] ? (-exp[14:10]) : (exp[14:10]+1);
            regime[19:15] = exp[19] ? (-exp[19:15]) : (exp[19:15]+1);

            REM1 = mant[16] ? ({{8{~exp[4]}},exp[4],mant[16:6]} >> regime[4:0]) : ({{8{~exp[4]}},exp[4],mant[15:5]} >> regime[4:0]);
            REM2 = mant[33] ? ({{8{~exp[9]}},exp[9],mant[33:23]} >> regime[9:5]) : ({{8{~exp[9]}},exp[9],mant[32:22]} >> regime[9:5]);
            REM3 = mant[50] ? ({{8{~exp[14]}},exp[14],mant[50:40]} >> regime[14:10]) : ({{8{~exp[14]}},exp[14],mant[49:39]} >> regime[14:10]);
            REM4 = mant[67] ? ({{8{~exp[19]}},exp[19],mant[67:57]} >> regime[19:15]) : ({{8{~exp[19]}},exp[19],mant[66:56]} >> regime[19:15]);

            L1[0] = REM1[5];
            G1[0] = REM1[4];
            R1[0] = REM1[3];
            St1[0] = REM1[2];
            ulp1[0] = ((G1[0] & (R1[0] | St1[0])) | (L1[0] & G1[0] & ~(R1[0] | St1[0])));
            ulp_REM1 = REM1[11:5] + ulp1[0];
            rnd_ulp_REM1 = (regime[4:0] < 6) ? ulp_REM1 : REM1[11:5];

            L1[1] = REM2[5];
            G1[1] = REM2[4];
            R1[1] = REM2[3];
            St1[1] = REM2[2];
            ulp1[1] = ((G1[1] & (R1[1] | St1[1])) | (L1[1] & G1[1] & ~(R1[1] | St1[1])));
            ulp_REM2 = REM2[11:5] + ulp1[1];
            rnd_ulp_REM2 = (regime[9:5] < 6) ? ulp_REM2 : REM2[11:5];

            L1[2] = REM3[5];
            G1[2] = REM3[4];
            R1[2] = REM3[3];
            St1[2] = REM3[2];
            ulp1[2] = ((G1[2] & (R1[2] | St1[2])) | (L1[2] & G1[2] & ~(R1[2] | St1[2])));
            ulp_REM3 = REM3[11:5] + ulp1[2];
            rnd_ulp_REM3 = (regime[14:10] < 6) ? ulp_REM3 : REM3[11:5];

            L1[3] = REM4[5];
            G1[3] = REM4[4];
            R1[3] = REM4[3];
            St1[3] = REM4[2];
            ulp1[3] = ((G1[3] & (R1[3] | St1[3])) | (L1[3] & G1[3] & ~(R1[3] | St1[3])));
            ulp_REM4 = REM4[11:5] + ulp1[3];
            rnd_ulp_REM4 = (regime[19:15] < 6) ? ulp_REM4 : REM4[11:5];

            out_r[7:0]   = s[0]?{s[0],(-rnd_ulp_REM1)}:{s[0],rnd_ulp_REM1};
            out_r[15:8]  = s[1]?{s[1],(-rnd_ulp_REM2)}:{s[1],rnd_ulp_REM2};
            out_r[23:16] = s[2]?{s[2],(-rnd_ulp_REM1)}:{s[2],rnd_ulp_REM3};
            out_r[31:24] = s[3]?{s[3],(-rnd_ulp_REM4)}:{s[3],rnd_ulp_REM4};
        end
        2'b01:begin


            regime[9:0] = exp[9] ? (-exp[9:1]) : (exp[9:1]+1);

            regime[19:10] = exp[19] ? (-exp[19:11]) : (exp[19:11]+1);


            REM5 = mant[33] ? ({{16{~exp[9]}},exp[9],exp[0],mant[33:15]} >> regime[9:0]) : ({{16{~exp[9]}},exp[9],exp[0],mant[32:15]} >> regime[9:0]);
           
            REM6 = mant[67] ? ({{16{~exp[19]}},exp[19],exp[10],mant[67:49]} >> regime[19:10]) : ({{16{~exp[19]}},exp[19],exp[10],mant[67:49]} >> regime[19:10]);

            L1[0] = REM5[6];
            G1[0] = REM5[5];
            R1[0] = REM5[4];
            St1[0] = REM5[3];
            ulp1[0] = ((G1[0] & (R1[0] | St1[0])) | (L1[0] & G1[0] & ~(R1[0] | St1[0])));
            ulp_REM5 = REM5[20:6] + ulp1[0];
            rnd_ulp_REM5 = (regime[9:0] < 13) ? ulp_REM5 : REM5[20:6];

            L1[1] = REM6[6];
            G1[1] = REM6[5];
            R1[1] = REM6[4];
            St1[1] = REM6[3];
            ulp1[1] = ((G1[1] & (R1[1] | St1[1])) | (L1[1] & G1[1] & ~(R1[1] | St1[1])));
            ulp_REM6 = REM6[20:6] + ulp1[1];
            rnd_ulp_REM6 = (regime[19:0] < 13) ? ulp_REM6 : REM6[20:6];
            out_r = {s[3],rnd_ulp_REM6,s[1],rnd_ulp_REM5};
        end
        2'b10:begin

            regime[19:0] = exp[19] ? (-exp[19:2]) : (exp[19:2]+1);
            REM7 = mant[67] ? ({{32{~exp[19]}},exp[19],exp[1:0],mant[67:33]} >> regime[19:0]) : ({{16{~exp[19]}},exp[19],exp[1:0],mant[67:33]} >> regime[19:0]);
            L1[0] = REM7[7];
            G1[0] = REM7[6];
            R1[0] = REM7[5];
            St1[0] = REM7[4];
            ulp1[0] = ((G1[0] & (R1[0] | St1[0])) | (L1[0] & G1[0] & ~(R1[0] | St1[0])));
            ulp_REM7 = REM7[37:7] + ulp1[0];
            rnd_ulp_REM7 = (regime[9:0] < 28) ? ulp_REM7 : REM7[37:7];
            out_r = {s[3],rnd_ulp_REM7};
        end
        default:begin
            regime=0;
            REM1=0;
            REM2=0;
            REM3=0;
            REM4=0;
            REM5=0;
            REM6=0;
            REM7=0;
            L1=0;G1=0;R1=0;St1=0;ulp1=0;
            rnd_ulp_REM1=0;rnd_ulp_REM2=0;rnd_ulp_REM3=0;rnd_ulp_REM4=0;
            ulp_REM1=0;ulp_REM2=0;ulp_REM3=0;ulp_REM4=0;
            ulp_REM5=0;ulp_REM6=0;rnd_ulp_REM5=0;rnd_ulp_REM6=0;
            ulp_REM7=0;rnd_ulp_REM7=0;
            out_r=0 ;
        end
    endcase
end

endmodule