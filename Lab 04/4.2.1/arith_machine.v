// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] q, d;
    wire [31:0] inst;
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [5:0]  opcode;
    wire [5:0]  funct;

    wire        wr_enable;
    wire        rd_src;
    wire [1:0]  alu_src2;
    wire [2:0]  alu_op;

    wire [4:0]  w_addr;
    wire [31:0] Rrs, Rrt, A_data, B_data;
    wire [31:0] w_data;
    wire        overflow, zero, negative;
    wire [31:0] sextimm, zextimm;

    // Complete the Control FSM components and add any missing components that you need
    
    register #(32) PC_reg(q, d, clock, 1'b1, reset);

    instruction_memory im(inst, q[31:2]);

    alu32 alu_top(d, , , , q, 32'h4, `ALU_ADD);

    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign opcode = inst[31:26];
    assign funct = inst[5:0];

    mips_decode mips_inst_decoder(rd_src, wr_enable, alu_src2, alu_op, except, opcode, funct);
    
    // Arithmetic Machine Datapath

    // sign-extended immediate
    assign sextimm = { {16{inst[15]}}, inst[15:0] };
    // zero-extended immediate
    assign zextimm = { {16{1'b0}}, inst[15:0] };

    // Register File and ALU
    mux2v #(5) rd_mux(w_addr, rd, rt, rd_src);

    regfile rf (Rrs, Rrt,
                rs, rt, w_addr, w_data,
                wr_enable, clock, reset);

    
    wire shift;
    wire [5:0] shamt;
    wire [31:0] B_data_temp, shift_final;
    assign shamt = inst[10:6];

    assign shift = (funct == `OP0_SLL) ? 1'b1 :
                   (funct == `OP0_SRA) ? 1'b1 :
                   (funct == `OP0_SRL) ? 1'b1 :
                   1'b0;

    // adding a mux btw Rrs and A_input of alu
    wire [1:0] control_shift;
    assign control_shift = (funct == `OP0_SLL) ? 2'd0 :
                           (funct == `OP0_SRL) ? 2'd1 :
                           2'd2;

    shift_unit shifter(shift_final, Rrt, shamt, control_shift);

    mux2v a_mask_switch(A_data, Rrs, 32'hffffffff, shift);
    mux2v b_control(B_data_temp, Rrt, shift_final, shift);

    mux3v alu_src2_mux(B_data, B_data_temp, sextimm, zextimm, alu_src2);

    alu32 alu(w_data, overflow, zero, negative, A_data, B_data, alu_op);

endmodule // arith_machine