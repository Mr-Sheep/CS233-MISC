
// a code generator for the ALU chain in the 32-bit ALU
// look at example_generator.cpp for inspiration

// 1-bit ALU module definition
// module alu1(out, carryout, A, B, carryin, control);

// make generator
// ./generator

#include <cstdio>
using std::printf;

int main() {
  int width = 32;
  // instantiation for ALU at index 0
  printf(
      "    alu1 alu%d(out[%d], cout_%d, A[%d], B[%d], control[0], control);\n",
      0, 0, 0, 0, 0);
  // iterates through the ALUs from index 1 to 31
  for (int i = 1; i < width; i++) {
    // we do i-1 for connecting carry output to carry input of the previous ALU
    printf(
        "    alu1 alu%d(out[%d], cout_%d, A[%d], B[%d], cout_%d, control);\n",
        i, i, i, i, i, i - 1);
  }

  for (int i = 31; i >= 0; i--) {
    printf("out[%d] + ", i);
  }
}
