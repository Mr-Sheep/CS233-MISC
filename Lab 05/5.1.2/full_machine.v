// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    // component for the PC part
    wire [31:0] PC, next_PC, next_pc_plus4, next_pc_plus_branch, jump_addr, branch_addr;
    wire [31:0] inst;
    wire [4:0]  rs, rt, rd, w_addr;
    wire [5:0]  opcode, funct;

    wire        wr_enable, rd_src, mem_read, byte_load, slt, lui, addm;
    wire [1:0]  alu_src2, control_type;
    wire [2:0]  alu_op;

    wire [31:0] Rrs, Rrt, B_data, alu_src2_out;
    wire [31:0] w_data, w_alu_out, w_slt_out, w_mem_read_out, w_addm_out, byte_load_out, addm_alu_out;
    wire        overflow, zero, negative;
    wire [31:0] sextimm, zextimm; 

    // some component for the data memory
    wire word_we, byte_we;
    wire [31:0] data_addr, data_in;
    wire [31:0] data_out;
    wire [31:0] byte_out;

    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    assign sextimm = { {16{inst[15]}}, inst[15:0] };
    assign zextimm = { {16{1'b0}}, inst[15:0] };
    assign branch_addr = { {14{inst[15]}}, inst[15:0], 2'b0 };
    assign jump_addr = { next_pc_plus4[31:28], inst[25:0], 2'b0 };


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, next_PC, clock, 1'b1, reset);

    alu32 pc_plus4(next_pc_plus4, , , , PC, 32'h4, `ALU_ADD);
    alu32 pc_plus_branch(next_pc_plus_branch, , , , next_pc_plus4, branch_addr, `ALU_ADD);
    alu32 alu(w_alu_out, overflow, zero, negative, Rrs, B_data, alu_op);
    alu32 addm_alu(addm_alu_out, , , , Rrt, data_out, `ALU_ADD);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    mips_decode mips_inst_decoder(alu_op, wr_enable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (Rrs, Rrt,
                rs, rt, w_addr, w_data,
                wr_enable, clock, reset);

    /* add other modules */
    data_mem data_memo(data_out, w_alu_out, Rrt, word_we, byte_we, clock, reset);

    mux4v #(32) data_mem_mux(byte_out, { 24'b0, data_out[7:0] }, {24'b0, data_out[15:8]}, {24'b0, data_out[23:16]}, {24'b0, data_out[31:24]}, w_alu_out[1:0]);
    mux4v #(32) control_PC(next_PC, next_pc_plus4, next_pc_plus_branch, jump_addr, Rrs, control_type);
    mux3v #(32) alu_src2_mux(alu_src2_out, Rrt, sextimm, zextimm, alu_src2);
    mux2v #(5) rd_mux(w_addr, rd, rt, rd_src);
    mux2v #(32) b_input_addm(B_data, alu_src2_out, 32'b0, addm);
    mux2v #(32) slt_mux(w_slt_out, w_alu_out, {31'b0, (negative ^ overflow)}, slt);
    mux2v #(32) byte_mux(byte_load_out, data_out, byte_out, byte_load);
    mux2v #(32) mem_read_mux(w_mem_read_out, w_slt_out, byte_load_out, mem_read);
    mux2v #(32) addm_mux(w_addm_out, w_mem_read_out, addm_alu_out, addm);
    mux2v #(32) lui_mux(w_data, w_addm_out, {inst[15:0], 16'b0}, lui);

endmodule // full_machine
