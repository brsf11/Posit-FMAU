module fulladder(
    output Sum,
    output Co,
    input A,
    input B,
    input Ci
    
);
wire s1,s2,s3;
xor(Sum,A,B,Ci);
and(S1,A,B);
xor(S2,A,B);
and(S3,Ci,S2);
or (Co,S1,S3);
endmodule