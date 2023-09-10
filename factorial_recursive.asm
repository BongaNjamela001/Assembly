.data
    input_prompt: .asciiz "Enter a number:\n"
    output_message: .asciiz "The result is:\n"
    newline: .asciiz "\n"
.text
.globl main

main:
    li $v0, 4
    la $a0, input_prompt
    syscall

    li $v0, 5
    syscall

    move $a0, $v0

    jal fac

    move $t0, $v0
    li $v0, 4
    la $a0, output_message
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j exit

fac:
    beq $a0, 0, condition

    addi $sp, $sp, -8
    sw $a0, 4($sp)
    sw $ra, ($sp)

    #move $t0, $a0

    addi $a0, $a0, -1

    jal fac

    lw $a0, 4($sp)
    lw $ra, ($sp)
    addi $sp, $sp, 8

    mul $v0, $a0, $v0

    jr $ra

condition:
    li $v0, 1
    jr $ra

exit:
    li $v0, 10
    syscall