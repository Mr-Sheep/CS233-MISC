.data
.align 2
# Test case 0
# The tree array has 128 integers
# Access this array only through calling conventions
test0_tree:
  .word 882 274 347 177 479 471 101 87 475 565 1023 376 525 563 959 795 876 421 904 348 171 964 907 703 619 1002 127 463 194 321 1008 471 491 501 10 658 270 368 397 536 264 834 321 214 311 605 530 192 138 454 712 1017 169 592 552 472 59 112 631 816 111 309 779 308 673 346 486 208 573 658 180 315 293 1022 246 973 624 31 789 905 727 643 1001 771 35 450 546 926 886 434 302 302 773 96 389 1005 572 108 818 960 460 623 125 160 700 714 372 462 337 238 67 643 593 705 1002 20 689 414 285 811 732 630 263 579 629 279 252 300
# Access this target only through calling conventions
test0_target: 
  .word 67
# Access this index only through calling conventions
test0_index: 
  .word 1

.text
.globl recursive_dfs
recursive_dfs:
    sub $sp, $sp, 20
    sw $ra, 0($sp)
    sw $s0, 4($sp)      # target
    sw $s1, 8($sp)      # i 
    sw $s2, 12($sp)     # tree
    sw $s3, 16($sp)     # ret
    
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    
    li $t0, 127
    
    # if (i <= 0 || i >= 127)
    ble $s1, $0, out 
    bge $s1, $t0, out
    
    mul $t1, $s1, 4      # t1 = 4i
    add $t1, $t1, $s2    # base + offset
    lw  $t2, 0($t1)      # lad tree[i]
    beq $s0, $t2, found
    
    mul $a1, $s1, 2
    move $a2, $s2
    jal recursive_dfs
    
    move $s3, $v0
    
    bge $s3, $0, ret_1
    
    mul $a1, $s1, 2
    addi $a1, $a1, 1
    move $a2, $s2
    jal recursive_dfs
    
    move $s3, $v0
    bge $s3, $0, ret_1
    move $v0, $s3
    j end

ret_1:
    addi $v0, $s3, 1
    j end
    
found:
    li $v0, 0
    j end
    
out:
    li $v0, -1
    j end

end:    
    lw $ra, 0($sp)
    lw $s0, 4($sp)      # target
    lw $s1, 8($sp)      # i 
    lw $s2, 12($sp)     # tree
    lw $s3, 16($sp)     # ret
    add $sp, $sp, 20
    jr $ra
