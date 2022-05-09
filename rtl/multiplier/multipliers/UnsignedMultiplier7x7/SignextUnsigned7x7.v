module SignextUnsigned7x7(input wire[31:0]  gen,
                          input wire[2:0]   sign,
                          output wire[10:0] pp00,
                          output wire[11:0] pp01,pp02,
                          output wire[9:0]  pp03);

    wire[2:0] ns;
    
    assign ns = ~sign;

    assign pp00 = {ns[0],sign[0],sign[0],gen[7:0]};
    assign pp01 = {1'b1,ns[1],gen[15:8],1'b0,sign[0]};
    assign pp02 = {1'b1,ns[2],gen[23:16],1'b0,sign[1]};
    assign pp03 = {gen[31:24],1'b0,sign[2]};

endmodule