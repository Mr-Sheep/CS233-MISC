//implement your 32-bit ALU
module alu32(out, overflow, zero, negative, A, B, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] A, B;
    input   [2:0] control;

    // wire [31:0] B_flipped;
    // assign B_flipped = (control == `ALU_SUB) ? (~B) : B;

    assign carryin_mod = (control == `ALU_SUB) ? 1'b1 : control[0];

    alu1 alu0(out[0], cout_0, A[0], B[0], carryin_mod, control);
    alu1 alu1(out[1], cout_1, A[1], B[1], cout_0, control);
    alu1 alu2(out[2], cout_2, A[2], B[2], cout_1, control);
    alu1 alu3(out[3], cout_3, A[3], B[3], cout_2, control);
    alu1 alu4(out[4], cout_4, A[4], B[4], cout_3, control);
    alu1 alu5(out[5], cout_5, A[5], B[5], cout_4, control);
    alu1 alu6(out[6], cout_6, A[6], B[6], cout_5, control);
    alu1 alu7(out[7], cout_7, A[7], B[7], cout_6, control);
    alu1 alu8(out[8], cout_8, A[8], B[8], cout_7, control);
    alu1 alu9(out[9], cout_9, A[9], B[9], cout_8, control);
    alu1 alu10(out[10], cout_10, A[10], B[10], cout_9, control);
    alu1 alu11(out[11], cout_11, A[11], B[11], cout_10, control);
    alu1 alu12(out[12], cout_12, A[12], B[12], cout_11, control);
    alu1 alu13(out[13], cout_13, A[13], B[13], cout_12, control);
    alu1 alu14(out[14], cout_14, A[14], B[14], cout_13, control);
    alu1 alu15(out[15], cout_15, A[15], B[15], cout_14, control);
    alu1 alu16(out[16], cout_16, A[16], B[16], cout_15, control);
    alu1 alu17(out[17], cout_17, A[17], B[17], cout_16, control);
    alu1 alu18(out[18], cout_18, A[18], B[18], cout_17, control);
    alu1 alu19(out[19], cout_19, A[19], B[19], cout_18, control);
    alu1 alu20(out[20], cout_20, A[20], B[20], cout_19, control);
    alu1 alu21(out[21], cout_21, A[21], B[21], cout_20, control);
    alu1 alu22(out[22], cout_22, A[22], B[22], cout_21, control);
    alu1 alu23(out[23], cout_23, A[23], B[23], cout_22, control);
    alu1 alu24(out[24], cout_24, A[24], B[24], cout_23, control);
    alu1 alu25(out[25], cout_25, A[25], B[25], cout_24, control);
    alu1 alu26(out[26], cout_26, A[26], B[26], cout_25, control);
    alu1 alu27(out[27], cout_27, A[27], B[27], cout_26, control);
    alu1 alu28(out[28], cout_28, A[28], B[28], cout_27, control);
    alu1 alu29(out[29], cout_29, A[29], B[29], cout_28, control);
    alu1 alu30(out[30], cout_30, A[30], B[30], cout_29, control);
    alu1 alu31(out[31], cout_31, A[31], B[31], cout_30, control);

    assign negative = out[31];
    assign zero = ~(out[31] | out[30] | out[29] | out[28] | out[27] | out[26] | out[25] | out[24] | out[23] | out[22] | out[21] | out[20] | out[19] | out[18] | out[17] | out[16] | out[15] | out[14] | out[13] | out[12] | out[11] | out[10] | out[9] | out[8] | out[7] | out[6] | out[5] | out[4] | out[3] | out[2] | out[1] | out[0]);
    xor xor_overflow(overflow, cout_31, cout_30);

endmodule // alu32
