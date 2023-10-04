.data
.align 2
# Test case 0
# An example test case where value = 0x0010
# Change this test case to more fully test your code
test0_value: .word 0x0011

.text
.globl has_single_bit_set
has_single_bit_set:

condition1:
    bne $a0, $0, condition2
    li $v0, 0    
    j done
    
condition2:
    sub $t0, $a0, 1
    and $t1, $a0, $t0
    beq $t1, $0, met
    li $v0, 0
    j done;

met:
    li $v0, 1
    j done
    
done:
    jr $ra




# bool has_single_bit_set(unsigned value) {  // returns 1 if a single bit is set
#   if (value == 0) {  
#     return 0;   // has no bits set
#   }
#   if (value & (value - 1)) {
#     return 0;   // has more than one bit set
#  }
#  return 1;
#}

