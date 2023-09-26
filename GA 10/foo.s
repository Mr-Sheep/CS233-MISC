# void foo(int* A, int x, int y){
#   int temp = 10 + bar(A[x]);
#   int baz = 3 - bar(y);
#   A[x-1] += temp * baz;  
# }

.data
.align 2
# Test case 0
test0_array:    .word 0 13 3 -4
test0_length:   .word 4
test0_xVal:     .word 2
test0_yVal:     .word 3
# Test case 1
test1_array:    .word 1 2 3 4 5 6 7 8 9
test1_length:   .word 9
test1_xVal:     .word 4
test1_yVal:     .word 5

.text
.globl  foo
foo:
# Write your code below here
    sub $sp, $sp, 32
    
    sw $ra, 0($sp) 
    sw $s1, 4($sp) # temp
    sw $s2, 8($sp) # baz
    sw $s3, 12($sp) # A
    sw $s4, 16($sp) # x
    sw $s5, 20($sp) # y
    sw $s6, 24($sp)
    sw $s7, 28($sp)
    
    move   $s3, $a0       # Load A
    move   $s4, $a1       # Load x
    move   $s5, $a2       # Load y
    
    mul $t1, $s4, 4         # $t1 = x * 4
    add $s7, $s3, $t1       # $t2 = a0 + offset
    
    # temp = 10 + bar(A[x])
    lw  $a0, 0($s7)         # load A[x] into $a0
    jal bar                 # call bar wtih A[x]
    move $s1, $v0
    addi $s1, $s1, 10       # save temp to $s1
    
    # baz = 3 - bar(y)
    move $a0, $s5
    li $s6, 3
    jal bar
    sub $s2, $s6, $v0

    # A[x-1] += temp * baz
    sub $s7, $s7, 4        # located A[x-1]  
    lw  $a0, 0($s7)
    mul $t2, $s2, $s1
    add $a0, $a0, $t2
    sw $a0, 0($s7)
    
    # clean up
    lw $ra, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $s6, 24($sp)
    lw $s7, 28($sp)
    
    addi $sp, $sp, 32

    jr $ra