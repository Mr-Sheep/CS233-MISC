.data
.align 2
# Test case 0
# An example test case where value = 0x0010
# Change this test case to more fully test your code
test0_value: .word 0x0100

.text
.globl get_lowest_set_bit
get_lowest_set_bit:

li $t2, 0               # i
li $t0, 1               # 1

for:
    bge $t2, 16, default
    
    and $t1, $a0, $t0
    beq $t1, $0, bit_shift

    move $v0, $t2
    j end
    
bit_shift:
    addi $t2, $t2, 1
    sll $t0, $t0, 1
    j for

default:
    li $v0, 0
    j end
    
end:
    jr $ra
    
# unsigned get_lowest_set_bit(unsigned value) {
#   for (int i = 0 ; i < 16 ; ++ i) {
#       if (value & (1 << i)) {          // test if the i'th bit position is set
#          return i;                     // if so, return i
#       }
#   }
#   return 0;
# }

