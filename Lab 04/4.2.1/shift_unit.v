module shift_unit(out, in, shamt, control);
    // When control == 00, shifts `in` logically to the left by shamt bits
    // When control == 01, shifts `in` logically to the right by shamt bits
    // When control == 10, shifts `in` arithmetically to the right by shamt bits

    output signed [31:0]   out;
    input signed [31:0]    in;
    input [4:0]     shamt;
    input [1:0]     control;

    wire [31:0]     sll = in << shamt;  // shift left logical by shamt
    wire [31:0]     srl = in >> shamt;  // shift right logical by shamt
    wire [31:0]     sra = in >>> shamt; // shift right arithmetic by shamt

    assign out = (({32{(control == 2'd0)}} & sll) |
                ({32{(control == 2'd1)}} & srl) |
                ({32{(control == 2'd2)}} & sra));
endmodule // end shift_unit