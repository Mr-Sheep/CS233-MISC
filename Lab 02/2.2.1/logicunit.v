// 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire        w00, w01, w10, w11;

    and  a0(w00, A, B);
    or   o0(w01, A, B);
    not  n0(w10, w01);
    xor  x0(w11, A, B);
    
    mux4 m0(out, w00, w01, w10, w11, control);
endmodule // logicunit