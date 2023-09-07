// a code generator for the a 32-bit register
// look at example_generator.py for inspiration

// 1-bit D-flip-flop with enable module definition
// module dffe(q, d, clk, enable, reset);

// make generator
// ./generator

#include <cstdio>
using std::printf;

int main() {
  printf("output [3:0] q;");
  printf("input [3:0] d");
  printf("input clk, enable, reset");

  // loop through all the address, and output to the corresponding q[i]
  int width = 32;
  for (int i = 2; i < width; i++) {
    printf("    dffe df%d(q[%d], d[%d], clk, enable, reset);\n", i, i, i);
  }
}