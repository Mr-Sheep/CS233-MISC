# In essence, int grid[3][3] is equivalent to int grid[9]. So to access an element in a 2D array, we can generically write the formula of array[row][col] as array[row * NUM_COLUMNS + col]. This will come in handy when converting the memory access in C to MIPS assembly.

# Constants
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
test0_A:
  .word 0x00010002 0x00040008 0x00100020 0x00400080 0x01000200 0x04000800 0x10002000 0x40008000
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

.text
.globl board_done
board_done:
    sub $sp, $sp, 16
    sw $ra, 0($sp) 
    sw $s0, 4($sp)      # i
    sw $s1, 8($sp)      # j
    sw $s2, 12($sp)     # a0
    
    li $s0, 0           # i
    move $s2, $a0       # save $a0 to $s2

for_i:
    bge $s0, GRID_SQUARED, exit_i
    li $s1, 0                           # j = 0

for_j:
    bge $s1, GRID_SQUARED, exit_j
    
    mul $t0, $s0, GRID_SQUARED          # $t0 = i * NUM_COLUMNS
    add $t1, $t0, $s1                   # $t1 = i * NUM_COLUMNS + j
    mul $t1, $t1, 2                     # *2
    add $t2, $t1, $s2                   # $t2 = $s2 + offset
    
    lhu $t3, 0($t2)                     # load the half word
    move $a0, $t3                       # move to $a0
    jal has_single_bit_set
    
    beq $v0, $0, false                  # if has_single_bit_set(board[i][j]) == 0
    
    addi $s1, $s1, 1                    # ++j
    j for_j
   
exit_j:
    addi $s0, $s0, 1                    # ++i
    j for_i

exit_i:
    li $v0, 1
    j end

false:
    li $v0, 0


end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)  
    lw $s1, 8($sp)  
    lw $s2, 12($sp)
    
    add $sp, $sp, 16
    jr $ra



