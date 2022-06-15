module fulladder(
    output Sum,
    output Co,
    input A,
    input B,
    input Ci
    
);
wire S1,S2,S3;
xor(Sum,A,B,Ci);
and(S1,A,B);
xor(S2,A,B);
and(S3,Ci,S2);
or (Co,S1,S3);
endmodule