////////////////////////////////////////////////////////////////////////
//
// Module: regfile
//
// Description:
//   A behavioral MIPS register file.  R0 is hardwired to zero.
//   Given that you won't write behavioral code, don't worry if you don't
//   understand how this works;  We have to use behavioral code (as
//   opposed to the structural code you are writing), because of the
//   latching by the the register file.
//
module regfile (rsData, rtData,
                rsNum, rtNum, rdNum, rdData,
                rdWriteEnable, clock, reset);

   output [31:0] rsData, rtData;
   input  [4:0]  rsNum, rtNum, rdNum;
   input  [31:0] rdData;
   input         rdWriteEnable, clock, reset;

   reg    [31:0] r[0:31];
   integer       i;

   always@(reset)
     if(reset == 1'b1)
       begin
          r[0] <= 32'b0;
          for(i = 1; i <= 31; i = i + 1)
            r[i] <= 32'h00000000;
       end

   assign #1 rsData = r[rsNum];
   assign #1 rtData = r[rtNum];

   wire [31:0] #1 internal_rdData = rdData;     // set up and hold time
   always@(posedge clock)
     begin
        if((reset == 1'b0) && (rdWriteEnable == 1'b1) && (rdNum != 5'b0))
          r[rdNum] <= internal_rdData;
     end

endmodule // regfile_3port

/// Comparator: Compares two values, A and B
//  lt: 1 if A is less than B
//  eq: 1 if A is equal to B
module comparator(lt, eq, A, B);
  parameter
     width = 32;

  output    lt, eq;
  input     [(width-1):0] A, B;
  assign lt = $signed(A) < $signed(B);
  assign eq = $signed(A) == $signed(B);
endmodule

// Here is an implementation of a 2-to-1 multiplexer for you to use
// output = A (when control == 0) or B (when control == 1)
module mux2(out, A, B, control);   // a 2-input multiplexer
   output      out;
   input       A, B;
   input       control;
   wire        wA, wB, not_control;

   not   n1(not_control, control);
   and   a1(wA, A, not_control);
   and   a2(wB, B, control);
   or    o1(out, wA, wB);
endmodule // mux2
