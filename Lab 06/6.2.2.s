# You can use GRID_SQUARED as a constant if you want 
# E.G., add $t0, $0, GRID_SQUARED
GRID_SQUARED = 16

.data
.align 2
# Test case 0
# A word is two elements in a row of the array
# e.g., 0x00010002 is two cells 0x0002 and 0x0001
# Remember memory is in Little Endian order, so 0x0002 is first
# Array A is a 16x16 array of shorts
# Try other test cases
# You can access this array only through calling conventions
test0_A:
  .word 0x00000000 0x00000000 0x00100020 0x00400080 0x01000200 0x04000800 0x10002000 0x40008000
  .word 0x00020004 0x00080001 0x00200040 0x00800010 0x02000400 0x08000100 0x20004000 0x80001000
  .word 0x00040008 0x00010002 0x00400080 0x00100040 0x04000800 0x01000200 0x40008000 0x10002000
  .word 0x00080001 0x00020004 0x00800010 0x00200080 0x08000100 0x02000400 0x80001000 0x20004000
  .word 0x00100020 0x00400080 0x01000200 0x04000800 0x10002000 0x40008000 0x00010002 0x00040008 
  .word 0x00200040 0x00800010 0x02000400 0x08000100 0x20004000 0x80001000 0x00020004 0x00080001
  .word 0x00400080 0x00100040 0x04000800 0x01000200 0x40008000 0x10002000 0x00040008 0x00010002
  .word 0x00800010 0x00200080 0x08000100 0x02000400 0x80001000 0x20004000 0x00080001 0x00020004
  .word 0x01000200 0x04000800 0x10002000 0x40008000 0x00010002 0x00040008 0x00100020 0x00400080
  .word 0x02000400 0x08000100 0x20004000 0x80001000 0x00020004 0x00080001 0x00200040 0x00800010
  .word 0x04000800 0x01000200 0x40008000 0x10002000 0x00040008 0x00010002 0x00400080 0x00100040
  .word 0x08000100 0x02000400 0x80001000 0x20004000 0x00080001 0x00020004 0x00800010 0x00200080
  .word 0x10002000 0x40008000 0x00010002 0x00040008 0x00100020 0x00400080 0x01000200 0x04000800
  .word 0x20004000 0x80001000 0x00020004 0x00080001 0x00200040 0x00800010 0x02000400 0x08000100
  .word 0x40008000 0x10002000 0x00040008 0x00010002 0x00400080 0x00100040 0x04000800 0x01000200
  .word 0x80001000 0x20004000 0x00080001 0x00020004 0x00800010 0x00200080 0x08000100 0x02000400

# You can access this global array directly
symbollist:
  .byte '0' '1' '2' '3' '4' '5' '6' '7' '8' '9' 'A' 'B' 'C' 'D' 'E' 'F' 'G'

.text
.globl print_board
print_board:

    sub     $sp, $sp, 28
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)                     # i
    sw      $s1, 8($sp)                     # j
    sw      $s2, 12($sp)                    # symbollist[]
    sw      $s3, 16($sp)                    # a0
    sw      $s4, 20($sp)                    # value
    sw      $s5, 24($sp)

    la      $s2, symbollist
    move    $s3, $a0
    li      $s0, 0                          # i = 0
    
    
for_i:
    bge     $s0, GRID_SQUARED, end
    li      $s1, 0                          # j = 0
    
for_j:
    bge     $s1, GRID_SQUARED, end_j
    
    mul     $t0, $s0, GRID_SQUARED          # $t0 = i * NUM_COLUMNS
    add     $t1, $t0, $s1                   # $t1 = i * NUM_COLUMNS + j
    mul     $t1, $t1, 2                     # *2
    add     $t2, $t1, $s3                   # $t2 = $s3 + offset

    lhu     $s4, 0($t2)                     # load unsigned short to value

   
    move    $a0, $s4
    jal     has_single_bit_set
    
    li      $s5, '*'                        # initialize c = '*'    
    beq     $v0, $0, skip_if                # has_single_bit_set(value) == false then skip

    move    $a0, $s4
    jal     get_lowest_set_bit
    addi    $t5, $v0, 1                     # get_lowest_set_bit(value) + 1;
    move    $t6, $s2
    add     $t6, $t6, $t5                   # num = base + get_lowest_set_bit(value) + 1;
    lb      $s5, 0($t6)                     # c = symbollist[num];
    
skip_if:                                    # printf("%c", c);
    move    $a0, $s5
    li      $v0, 11                              
    syscall
    addi    $s1, $s1, 1
    j       for_j

end_j:
    li      $a0, '\n'
    li      $v0, 11
    syscall
    addi    $s0, $s0, 1                     # ++i
    j for_i

end:
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    lw      $s3, 16($sp)
    lw      $s4, 20($sp)
    lw      $s5, 24($sp)
    add     $sp, $sp, 28

    jr      $ra

