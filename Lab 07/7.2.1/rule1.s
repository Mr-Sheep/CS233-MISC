# Constants
# You can use GRID_SQUARED as a constant if you want 
# E.G., add $t0, $0, GRID_SQUARED
GRID_SQUARED = 16
GRIDSIZE = 4

.data
.align 2
# Test case 0
# Everything after .half is a halfword sized piece of data (a.k.a. shorts)
# board is a 16x16 array of shorts
# Each hex number is an element of the array
# Each row of test0_board is a row of the array
# Try other test cases
test0_board:
  .half 0x0002 0x0001 0x0008 0x0004 0x0020 0x0010 0x0080 0x0040 0x0200 0x0100 0x0800 0x0400 0x2000 0x1000 0x8000 0x4000
  .half 0x0020 0x0010 0x0080 0x0040 0x0200 0x0100 0x0800 0x0400 0x2000 0x1000 0x8000 0x4000 0x0002 0x0001 0x0008 0x0004
  .half 0x0200 0x0100 0x0800 0x0400 0x2000 0x1000 0x8000 0x4000 0x0002 0x0001 0x0008 0x0004 0x0020 0x0010 0x0080 0x0040
  .half 0x2000 0x1000 0x8000 0x4000 0x0002 0x0001 0x0008 0x0004 0x0020 0x0010 0x0080 0x0040 0x0200 0x0100 0x0800 0x0400
  .half 0x0004 0x0002 0x0001 0x0008 0x0040 0x0020 0x0010 0x0080 0x0400 0x0200 0x0100 0x0800 0x4000 0x2000 0x1000 0x8000
  .half 0x0040 0x0020 0x0010 0x0080 0x0400 0x0200 0x0100 0x0800 0x4000 0x2000 0x1000 0x8000 0x0004 0x0002 0x0001 0x0008
  .half 0x0400 0x0200 0x0100 0x0800 0x4000 0x2000 0x1000 0x8000 0x0004 0x0002 0x0001 0x0008 0x0040 0x0020 0x0010 0x0080
  .half 0x4000 0x2000 0x1000 0x8000 0x0004 0x0002 0x0001 0x0008 0x0040 0x0020 0x0010 0x0080 0x0400 0x0200 0x0100 0x0800
  .half 0x0008 0x0004 0x0002 0x0001 0x0080 0x0040 0x0020 0x0010 0x0800 0x0400 0x0200 0x0100 0x8000 0x4000 0x2000 0x1000
  .half 0x0082 0x0040 0x0020 0x0010 0x0800 0x0400 0x0200 0x0100 0x8000 0x4000 0x2000 0x1000 0x0008 0x0004 0x0002 0x0001
  .half 0x0800 0x0400 0x0200 0x0100 0x8000 0x4000 0x2000 0x1000 0x0008 0x0004 0x0002 0x0001 0x0080 0x0040 0x0020 0x0010
  .half 0x8000 0x4000 0x2000 0x1000 0x0008 0x0004 0x0002 0x0001 0x0080 0x0040 0x0020 0x0010 0x0800 0x0400 0x0200 0x0100
  .half 0x0001 0x0008 0x0004 0x0002 0x0010 0x0080 0x0040 0x0020 0x0100 0x0800 0x0400 0x0200 0x1000 0x8000 0x4000 0x2000
  .half 0x0010 0x0080 0x0040 0x0020 0x0100 0x0800 0x0400 0x0200 0x1000 0x8000 0x4000 0x2000 0x0001 0x0008 0x0004 0x0002
  .half 0x0100 0x0800 0x0400 0x0200 0x1000 0x8000 0x4000 0x2000 0x0001 0x0008 0x0004 0x0002 0x0010 0x0080 0x0040 0x0020
  .half 0x1000 0x8000 0x4000 0x2000 0x0001 0x0008 0x0004 0x0002 0x0010 0x0080 0x0040 0x0020 0x0100 0x0800 0x0400 0x0200

.text
.globl rule1
rule1:

    sub     $sp, $sp, 32
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)                     # a0
    sw      $s1, 8($sp)                     # i
    sw      $s2, 12($sp)                    # j
    sw      $s3, 16($sp)                    # changed
    sw      $s4, 20($sp)                    # value
    sw      $s5, 24($sp)                    # ii
    sw      $s6, 28($sp)                    # jj

    move    $s0, $a0
    li      $s1, 0                          # i = 0
    li      $s3, 0                          # changed = false

for_i:
    bge     $s1, GRID_SQUARED, end
    li      $s2, 0

for_j:
    bge     $s2, GRID_SQUARED, end_i

    # load value
    mul     $t0, $s1, GRID_SQUARED          # $t0 = i * NUM_COLUMNS
    add     $t0, $t0, $s2                   # $t0 = i * NUM_COLUMNS + j
    mul     $t0, $t0, 2                     # *2
    add     $t0, $t0, $s0                   # $t2 = $s0 + offset
    lhu     $s4, 0($t0)

    move    $a0, $s4
    jal     has_single_bit_set

    beq     $v0, $0, end_j                  # if(has_single_bit_set(value))

    li      $t1, 0                          # first k = 0

for_k_1:
    bge     $t1, GRID_SQUARED, end_k_1
    
    beq     $t1, $s2, second_if             # if (k != j)

    mul     $t0, $s1, GRID_SQUARED          # $t0 = i * NUM_COLUMNS
    add     $t0, $t0, $t1                   # $t1 = i * NUM_COLUMNS + k
    mul     $t0, $t0, 2                     # *2
    add     $t0, $t0, $s0                   # $t0 = $s0 + offset

    lhu     $t2, 0($t0)                     # $t2 = board[i][k]

    and     $t3, $t2, $s4                   # board[i][k] & value
    beq     $t3, $0, second_if              # if (board[i][k] & value)
    not     $t4, $s4                        # ~value;
    and     $t4, $t4, $t2                   # board[i][k] & ~value;
    sh      $t4, 0($t0)                     # board[i][k] &= ~value;
    li      $s3, 1                          # changed = true;

second_if:
    beq     $t1, $s1, end_one_k

    mul     $t5, $t1, GRID_SQUARED          # $t5 = k * NUM_COLUMNS
    add     $t5, $t5, $s2                   # $t5 = k * NUM_COLUMNS + j
    mul     $t5, $t5, 2                     # *2
    add     $t5, $s0, $t5                   # $t5 = $s0 + offset

    lhu     $t6, 0($t5)                     # $t6 = board[k][j]
    and     $t7, $t6, $s4                   # board[k][j] & value
    beq     $t7, $0, end_one_k              # if (board[k][j] & value)
    not     $t8, $s4                        # ~value
    and     $t8, $t8, $t6                   # board[k][j] & ~value;
    sh      $t8, 0($t5)                     # board[k][j] &= ~value;
    li      $s3, 1                          # changed = true

end_one_k:
    addi    $t1, $t1, 1
    j       for_k_1

# assume all temp register cleared?

end_k_1:
    move    $a0, $s1
    jal     get_square_begin
    move    $s5, $v0                        # int ii = get_square_begin(i);

    move    $a0, $s2
    jal		get_square_begin
    move    $s6, $v0                        # int jj = get_square_begin(j);

    move    $t1, $s5                        # k = ii

for_k_2:
    add     $t3, $s5, GRIDSIZE              # ii + GRIDSIZE
    bge		$t1, $t3, end_j	
    move    $t2, $s6                        # l = jj

for_l:
    add     $t4, $s6, GRIDSIZE              # jj + GRIDSIZE
    bge     $t2, $t4, end_k_2               # end for (l) when l >= jj + GRIDSIZE
 
    bne     $t1, $s1, not_true              # run the loop as it is when (k != i)
    bne     $t2, $s2, not_true              # run the look as it is when (l != j)   
    j       end_l

    # I think this also works, but not sure
    # bne     $t1, $s1, not_true             # run the loop as it is when (k != i)
    # beq     $t2, $s2, end_l                # run the look as it is when (l != j)   

not_true:
    mul     $t5, $t1, GRID_SQUARED          # $t5 = k * NUM_COLUMNS
    add     $t5, $t5, $t2                   # $t5 = k * NUM_COLUMNS + l
    mul     $t5, $t5, 2                     # *2
    add     $t5, $s0, $t5                   # $t5 = $s0 + offset

    lhu     $t6, 0($t5)                     # $t6 = board[k][l]
    and     $t7, $t6, $s4                   # board[k][l] & value
    beq     $t7, $0, end_l                  # if (board[k][l] & value)
    not     $t4, $s4                        # ~value
    and     $t4, $t4, $t6                   # board[k][l] & ~value;
    sh      $t4, 0($t5)                     # board[k][l] &= ~value;
    li      $s3, 1                          # changed = true

end_l:
    addi    $t2, $t2, 1
    j       for_l


end_k_2: 
    addi    $t1, $t1, 1
    j		for_k_2				            # jump to for_k_2
    
end_j:
    addi    $s2, $s2, 1
    j       for_j

end_i:
    addi    $s1, $s1, 1
    j       for_i

end: 
    move    $v0, $s3
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)                     # a0
    lw      $s1, 8($sp)                     # i
    lw      $s2, 12($sp)                    # j
    lw      $s3, 16($sp)                    # changed
    lw      $s4, 20($sp)                    # value
    lw      $s5, 24($sp)                    # ii
    lw      $s6, 28($sp)                    # jj
    add     $sp, $sp, 32
    jr      $ra