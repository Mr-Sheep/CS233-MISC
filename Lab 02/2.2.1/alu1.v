module full_adder(sum, cout, a, b, cin);
    output sum, cout;
    input  a, b, cin;
    wire   partial_s, partial_c1, partial_c2;

    xor x0(partial_s, a, b);
    xor x1(sum, partial_s, cin);
    and a0(partial_c1, a, b);
    and a1(partial_c2, partial_s, cin);
    or  o1(cout, partial_c1, partial_c2);
endmodule // full_adder

module logic_unit(out, A, B, C, D, control);
    output out;
    input A, B, C, D;
    input [1:0] control;

    wire wA, wB, wC, wD;

    assign wA = A & (control == 2'b00);
    assign wB = B & (control == 2'b01);
    assign wC = C & (control == 2'b10);
    assign wD = D & (control == 2'b11);

    or o1(out, wA, wB, wC, wD);

endmodule // logic_unit

`define ALU_ADD    3'h2
`define ALU_SUB    3'h3
`define ALU_AND    3'h4
`define ALU_OR     3'h5
`define ALU_NOR    3'h6
`define ALU_XOR    3'h7

// 01x -> arithmetic, 1xx -> logic
module alu1(out, carryout, A, B, carryin, control);
    output      out, carryout;
    input       A, B, carryin;
    input [2:0] control;

    // add code here!!!
    wire w_adder, w_logic;

    // full adder part
    wire adder_B;
    xor x1(adder_B, B, control[0]);

    // assign neg_B = (control == `ALU_SUB) ? ~B : B;
    // assign carryin_mod = (control == `ALU_SUB) ? 1'b1 : carryin;
    
    full_adder adder1(w_adder, carryout, A, adder_B, carryin);

    // logical unit part
    wire A_and_B, A_or_B, A_nor_B, A_xor_B;
    and and1(A_and_B, A, B);
    or or1(A_or_B, A, B);
    nor nor1(A_nor_B, A, B);
    xor xor1(A_xor_B, A, B);

    logic_unit l1(w_logic, A_and_B, A_or_B, A_nor_B, A_xor_B, control[1:0]);

    // wire w_adder_out, w_logic_out;
    // assign w_adder_out = w_adder & (control[2:1] == 2'b01);
    // assign w_logic_out = w_logic & (control[2] == 1'b1);
    
    // or o1(out, w_adder_out, w_logic_out);

    assign out = (control[2] == 1'b1) ? w_logic : w_adder;
   
endmodule // alu1
