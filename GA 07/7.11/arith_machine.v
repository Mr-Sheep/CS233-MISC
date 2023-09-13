module arith_machine(rs, rt, rd, rd_src, wr_enable, alu_src2, alu_op, imm16, NEG, clock, reset);
    input        rd_src, wr_enable, NEG;
    input [1:0]  alu_src2;
    input [2:0]  alu_op;
    input [15:0] imm16;
    input [4:0]  rs, rt, rd;
    input        clock, reset;

    wire [4:0] rss;
    wire [31:0]  sextimm, zextimm;

    wire [4:0]   w_addr;

    // sign-extended immediate
    assign sextimm = { {16{imm16[15]}}, imm16[15:0] };

    // zero-extended immediate
    assign zextimm = { {16{1'b0}}, imm16[15:0] };

    wire [31:0]  Rrs, Rrt, B_data;
    wire [31:0]  w_data;

    mux2v #(5) rd_neg(rss, rs,  5'b0, NEG);

    mux2v #(5) rd_mux(w_addr, rd, rt, rd_src);

    regfile rf (Rrs, Rrt,
                rss, rt, w_addr, w_data,
                wr_enable, clock, reset);

    mux3v alu_src2_mux(B_data, Rrt, sextimm, zextimm, alu_src2);

    alu32 alu(w_data, Rrs, B_data, alu_op);
endmodule // arith_machine
