
module chopUpDigits_control (done, get_new, load_index, load_number, select_base, write, base, number_is_0, go, clk, reset);
	output done, get_new, load_index, load_number, select_base, write;
	input base, number_is_0, go;
	input clk, reset;

	wire sGarbage, sStart, sWhile8, sWhile16, sWrite8, sWrite16, sDone;

	wire sGarbage_next = (sGarbage & ~go) | reset;
	wire sStart_next = ((sGarbage & go) | (sStart & go) | (sDone & go)) & ~reset;
	wire sWhile8_next = ((sStart & (~go & ~base)) | sWrite8) & ~reset;
	wire sWhile16_next = ((sStart & (~go & base)) | sWrite16) & ~reset;
	wire sWrite8_next = (sWhile8 & ~number_is_0) & ~reset;
	wire sWrite16_next = (sWhile16 & ~number_is_0) & ~reset;
	wire sDone_next = ((sWhile8 & number_is_0) | (sWhile16 & number_is_0) | (sDone & ~go)) & ~reset;

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
  assign select_base = sWrite16;
  assign write = (sWrite8 | sWrite16);

	assign done = sDone;
endmodule
