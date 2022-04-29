module SignedMultiplier8x8(input wire[7:0]   A,B,
                     output wire[15:0] out);

    ModRadix4BoothGen MR4BG0
    #(
        .width(8)
    )
    (
        .B      (),
        .A      (),
        .gen    (),
        .sign   ()
    );

endmodule