module keypad(valid, number, a, b, c, d, e, f, g);
   output   valid;
   output [3:0] number;
   input  a, b, c, d, e, f, g;

   wire na, nb, nc, nd, ne, nf, ng;

   not n1(na, a);
   not n2(nb, b);
   not n3(nc, c);
   not n4(nd, d);
   not n5(ne, e);
   not n6(nf, f);
   not n7(ng, g);

   // possible combinations:

   wire p0, p1, p2, p3, p4, p5, p6, p7, p8, p9;

   and a0(p0, na, b, nc, nd, ne, nf, g); // bg 0000
   and a1(p1, a, nb, nc, d, ne, nf, ng); // ad 0001
   and a2(p2, na, b, nc, d, ne, nf, ng); // bd 0010
   and a3(p3, na, nb, c, d, ne, nf, ng); // cd 0011
   and a4(p4, a, nb, nc, nd, e, nf, ng); // ae 0100
   and a5(p5, na, b, nc, nd, e, nf, ng); // be 0101
   and a6(p6, na, nb, c, nd, e, nf ,ng); // ce 0110
   and a7(p7, a, nb, nc, nd, ne, f, ng); // af 0111
   and a8(p8, na, b, nc, nd, ne, f, ng); // bf 1000
   and a9(p9, na, nb, c, nd, ne, f, ng); // cf 1001

   or ov(valid, p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);

   // lsb - msb (wtf is wrong with the order....)
   assign number[0] = p9 | p7 | p5 | p3 | p1 | 2'b0;  // 1, 3, 5, 7, 9
   assign number[1] = p7 | p6 | p3 | p2 | 2'b0;       // 2, 3, 6, 7
   assign number[2] = p7 | p6 | p5 | p4 | 2'b0;       // 4, 5, 6, 7
   assign number[3] = p8 | p9 | 2'b0;                 // 8, 9


   assign number[0] = p9 | p7 | p5 | p3 | p1;  // 1, 3, 5, 7, 9
   assign number[1] = p7 | p6 | p3 | p2;       // 2, 3, 6, 7
   assign number[2] = p7 | p6 | p5 | p4;       // 4, 5, 6, 7
   assign number[3] = p8 | p9;                 // 8, 9

endmodule // keypad
