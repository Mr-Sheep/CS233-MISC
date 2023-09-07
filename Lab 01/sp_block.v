module sc_block(out, A, B);
  output  out;
  input   A, B;
  // out = 1 when an odd number of input bits is 1
  // out = 0 when an even number of input bits is 1 (zero is even)
  // add your code below here

  xor x1(out, A, B);

endmodule // odd_even2

module odd_even3(out, A, B, C);
  // out = 1 when an odd number of input bits is 1
  // out = 0 when an even number of input bits is 1 (zero is even)
  // add your code below here
  output out;
  input A, B, C;

  wire w1;
  odd_even2 oe1(w1, A, B);

  odd_even2 oe2(out, w1, C);

  // DO NOT USE ANY GATES!!! FOLLOW THE SCHEMATIC SHOWN IN THE INSTRUCTIONS EXACTLY
  // USE MULTIPLE INSTANCES OF odd_even2, SEE INSTRUCTIONS FOR HOW TO DO THAT.

   
endmodule // odd_even3