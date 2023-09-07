`define ALU_ADD    3'h0
`define ALU_SUB    3'h1

// chopUpDigits datapath
module chopUpDigits_circuit(number_is_0, get_new, load_index, load_number, select_base, write, number, digits_ptr, clk, reset);
	output number_is_0;
	input get_new, load_index, load_number, select_base, write;
	input [31:0] number;
	input [4:0] digits_ptr;
	input clk, reset;

	reg [31:0]  number_reg;
	reg [4:0] digits_ptr_reg, index_reg;

	wire [31:0] div_8 = {3'b0, number_reg[31:3]};
	wire [31:0] mod_8 = {29'b0, number_reg[2:0]};
	wire [31:0] div_16 = {4'b0, number_reg[31:4]};
	wire [31:0] mod_16 = {28'b0, number_reg[3:0]};

	always@(posedge clk)
	begin
		if (reset == 1'b1)
			begin
				number_reg <= 0;
				digits_ptr_reg <= 0;
				index_reg <= 0;
			end
		else
			begin
				if(~reset && get_new)
				begin
					digits_ptr_reg <= digits_ptr;
				end

				if(~reset && load_number && get_new)
				begin
					number_reg <= number;
				end

				if(~reset && load_number && ~get_new && ~select_base)
				begin
					number_reg <= div_8;
				end

				if(~reset && load_number && ~get_new && select_base)
				begin
					number_reg <= div_16;
				end

				if(~reset && load_index && get_new)
				begin
					index_reg <= 0;
				end

				if (~reset && load_index && ~get_new)
				begin
					index_reg <= index_reg + 1;
				end
			end
		end

	wire [4:0] digit_ptr_plus_index;
	wire [31:0] write_data;
	
	assign write_data = select_base ? mod_16 : mod_8;
	assign digit_ptr_plus_index = digits_ptr_reg + index_reg;
	regfile rf( , , , , digit_ptr_plus_index, write_data, write, clk, reset);

	comparator #(32) compareNumber( , number_is_0, number_reg, 32'b0);

endmodule
