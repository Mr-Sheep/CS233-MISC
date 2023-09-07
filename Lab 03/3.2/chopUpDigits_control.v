
module chopUpDigits_control (done, get_new, load_index, load_number, select_base, write, base, number_is_0, go, clk, reset);
	output done, get_new, load_index, load_number, select_base, write;
	input base, number_is_0, go;
	input clk, reset;

	assign temp_base = base;
	assign temp_go = go;

	wire sGarbage, sStart, sWhile8, sWhile16, sWrite8, sWrite16, sDone;

	wire sGarbage_next = (sGarbage & ~temp_go) | reset;
	wire sStart_next = ((sGarbage & temp_go) | (sStart & temp_go) | (sDone & temp_go)) & ~reset;
	wire sWhile8_next = ((sStart & (~temp_go & ~temp_base)) | sWrite8) & ~reset;
	wire sWhile16_next = ((sStart & (~temp_go & temp_base)) | sWrite16) & ~reset;
	wire sWrite8_next = (sWhile8 & ~number_is_0) & ~reset;
	wire sWrite16_next = (sWhile16 & ~number_is_0) & ~reset;
	wire sDone_next = ((sWhile8 & number_is_0) | (sWhile16 & number_is_0) | (sDone & ~temp_go)) & ~reset;

	dffe fsGarbage(sGarbage, sGarbage_next, clk, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clk, 1'b1, 1'b0);
	dffe fsWhile8(sWhile8, sWhile8_next, clk, 1'b1, 1'b0);
	dffe fsWhile16(sWhile16, sWhile16_next, clk, 1'b1, 1'b0);
	dffe fsWrite8(sWrite8, sWrite8_next, clk, 1'b1, 1'b0);
	dffe fsWrite16(sWrite16, sWrite16_next, clk, 1'b1, 1'b0);
	dffe fsDone(sDone, sDone_next, clk, 1'b1, 1'b0);

	assign load_number = (sStart | sWrite8 | sWrite16);
	assign load_index = (sStart | sWrite8 | sWrite16);
	assign get_new = sStart;
    assign select_base = temp_base;
    assign write = (sWrite8 | sWrite16);

	// chopUpDigits_circuit c1(number_is_0, get_new, load_index, load_number, select_temp_base, write, number, digits_ptr, clk, reset);
	assign done = sDone;
endmodule
