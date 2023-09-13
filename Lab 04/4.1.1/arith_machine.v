module arith_machine(rs, rt, rd, rd_src, wr_enable, alu_src2, alu_op, imm16, NOT, clock, reset);
    input        rd_src, wr_enable, NOT;
    input [1:0]  alu_src2;
    input [2:0]  alu_op;
    input [15:0] imm16;
    input [4:0]  rs, rt, rd;
    input        clock, reset;

    wire [31:0]  sextimm, zextimm;

    wire [4:0]   w_addr;

    // sign-extended immediate
    assign sextimm = { {16{imm16[15]}}, imm16[15:0] };

    // zero-extended immediate
    assign zextimm = { {16{1'b0}}, imm16[15:0] };

    wire [31:0]  Rrs, Rrt, A_data, B_data, B_data_temp;
    wire [31:0]  alu_out, adder_out, w_data;


    mux2v #(5) rd_mux(w_addr, rd, rt, rd_src);
    

    regfile rf (Rrs, Rrt,
                rs, rt, w_addr, w_data,
                wr_enable, clock, reset);

    mux3v alu_src2_mux(B_data_temp, Rrt, sextimm, zextimm, alu_src2);

    mux2v neg_mux1(B_data, B_data_temp, Rrs, NOT);

    alu32 alu(w_data, Rrs, B_data, alu_op);
endmodule // arith_machine
