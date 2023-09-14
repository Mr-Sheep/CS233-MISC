// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// wr_enable   (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, wr_enable, alu_src2, alu_op, except, opcode, funct);
output       rd_src, wr_enable, except;
output [1:0] alu_src2;
output [2:0] alu_op;
input  [5:0] opcode, funct;

wire   [3:0] alu_op0;
wire         op0, addu_inst, add_inst, sub_inst, and_inst, or_inst, xor_inst, nor_inst;
wire         addi_inst, addiu_inst, andi_inst, ori_inst, xori_inst;
wire         sll_inst, sra_insta, srl_inst;

assign op0 = (opcode == `OP_OTHER0);
assign addu_inst = op0 & (funct == `OP0_ADDU);
assign add_inst = op0 & (funct == `OP0_ADD);
assign sub_inst = op0 & (funct == `OP0_SUB);
assign and_inst = op0 & (funct == `OP0_AND);
assign or_inst  = op0 & (funct == `OP0_OR);
assign xor_inst = op0 & (funct == `OP0_XOR);
assign nor_inst = op0 & (funct == `OP0_NOR);

// adding new R type instructions
// all of them writes to R[rd] and alu_src2 should also be 0.
// alu_op2 should be AND
// https://inst.eecs.berkeley.edu/~cs61bl/r/cur/bits/bit-shifting.html?topic=lab28.topic&step=4&course=
assign sll_inst = op0 & (funct == `OP0_SLL);
assign sra_inst = op0 & (funct == `OP0_SRA); // fill in vacated places with value of the MSB
assign srl_inst = op0 & (funct == `OP0_SRL); // fill in vacated places with 0s 

// end

assign addi_inst = (opcode == `OP_ADDI);
assign addiu_inst = (opcode == `OP_ADDIU);
assign andi_inst = (opcode == `OP_ANDI);
assign ori_inst = (opcode == `OP_ORI);
assign xori_inst = (opcode == `OP_XORI);

// alu_op behavior:
// 3'b000 undefined
// 3'b001 undefined
// 3'b010 add
// 3'b011 sub
// 3'b100 and (sll, sra, srl)
// 3'b101 or
// 3'b110 nor
// 3'b111 xor
assign alu_op[0] = sub_inst | or_inst | xor_inst | ori_inst | xori_inst;
assign alu_op[1] = add_inst | sub_inst | xor_inst | nor_inst | addi_inst | xori_inst;
assign alu_op[2] = and_inst | or_inst | xor_inst | nor_inst | andi_inst | ori_inst | xori_inst | sll_inst | sra_inst | srl_inst;

assign except = ~(add_inst | addu_inst | sub_inst | and_inst | or_inst | xor_inst | nor_inst | addi_inst | addiu_inst | andi_inst | ori_inst | xori_inst | sll_inst | sra_inst | srl_inst);
assign wr_enable = ~except;
assign rd_src = addi_inst | addiu_inst | andi_inst | ori_inst | xori_inst;

assign alu_src2[0] = addi_inst | addiu_inst;
assign alu_src2[1] = andi_inst | ori_inst | xori_inst;

endmodule // mips_decode