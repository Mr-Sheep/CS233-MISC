// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire         op0, addu_inst, add_inst, sub_inst, and_inst, or_inst, xor_inst, nor_inst;
    wire         addi_inst, addiu_inst, andi_inst, ori_inst, xori_inst;
    wire         beq_inst, bne_inst, j_inst, jr_inst, lui_inst, slt_inst, lw_inst, lbu_inst, sw_inst, sb_inst, addm_inst;

    assign op0 = (opcode == `OP_OTHER0);
    assign addu_inst = op0 & (funct == `OP0_ADDU);
    assign add_inst = op0 & (funct == `OP0_ADD);
    assign sub_inst = op0 & (funct == `OP0_SUB);
    assign and_inst = op0 & (funct == `OP0_AND);
    assign or_inst  = op0 & (funct == `OP0_OR);
    assign xor_inst = op0 & (funct == `OP0_XOR);
    assign nor_inst = op0 & (funct == `OP0_NOR);

    assign jr_inst = op0 &  (funct == `OP0_JR);
    assign slt_inst = op0 & (funct == `OP0_SLT);
    assign addm_inst = op0 & (funct == `OP0_ADDM);

    assign addi_inst = (opcode == `OP_ADDI);
    assign addiu_inst = (opcode == `OP_ADDIU);
    assign andi_inst = (opcode == `OP_ANDI);
    assign ori_inst = (opcode == `OP_ORI);
    assign xori_inst = (opcode == `OP_XORI);

    assign beq_inst = (opcode == `OP_BEQ);
    assign bne_inst = (opcode == `OP_BNE);
    assign j_inst = (opcode == `OP_J); // j-type
    assign lui_inst = (opcode == `OP_LUI);
    assign lw_inst = (opcode == `OP_LW);
    assign lbu_inst = (opcode == `OP_LBU);
    assign sw_inst = (opcode == `OP_SW);
    assign sb_inst = (opcode == `OP_SB);

    // 00 = fallthrough, 01 = branch_target, 
    // 10 = jump_target, 11 = jump_register 

    assign control_type[0] = ((beq_inst & zero) | (bne_inst & ~zero) | jr_inst);
    assign control_type[1] = (j_inst | jr_inst);

    assign alu_op[0] = sub_inst | or_inst | xor_inst | ori_inst | xori_inst | bne_inst | beq_inst | slt_inst;
    assign alu_op[1] = add_inst | sub_inst | xor_inst | nor_inst | addi_inst | xori_inst | bne_inst | beq_inst | slt_inst | lw_inst | lbu_inst | sw_inst | sb_inst | addm_inst;
    assign alu_op[2] = and_inst | or_inst | xor_inst | nor_inst | andi_inst | ori_inst | xori_inst;

    assign except = ~(add_inst | addu_inst | sub_inst | and_inst | or_inst | xor_inst | nor_inst | addi_inst | addiu_inst | andi_inst | ori_inst | xori_inst | beq_inst | bne_inst | j_inst | jr_inst | lui_inst | slt_inst | lw_inst | lbu_inst | sw_inst | sb_inst | addm_inst);
    assign writeenable = (add_inst | addu_inst | sub_inst | and_inst | or_inst | xor_inst | nor_inst | addi_inst | addiu_inst | andi_inst | ori_inst | xori_inst | lui_inst | slt_inst | lw_inst | lbu_inst | addm_inst);
    assign rd_src = addi_inst | addiu_inst | andi_inst | ori_inst | xori_inst | lw_inst | lui_inst | lbu_inst;

    assign alu_src2[0] = addi_inst | addiu_inst | lbu_inst | lw_inst | sb_inst | sw_inst;
    assign alu_src2[1] = andi_inst | ori_inst | xori_inst;

    assign word_we = sw_inst;
    assign byte_we = sb_inst;
    assign slt = slt_inst;
    assign byte_load = lbu_inst;
    assign mem_read = lw_inst | lbu_inst | addm_inst;   
    assign lui = lui_inst;
    assign addm = addm_inst;


endmodule // mips_decode
