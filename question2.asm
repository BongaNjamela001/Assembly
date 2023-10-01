.data				#Declare memory and constants
    input_prompt:    .asciiz "Enter a dividend and divisor:\n"
    q_message:       .asciiz "Quotient:\n"
    r_message:	     .asciiz "Remainder:\n"
    error_message:   .asciiz "Error: Division by zero.\n" 
    new_line:        .asciiz "\n"
.text
.globl main

main:
  #Prompt for dividend n and divisor m
  li $v0, 4
  la $a0, input_prompt
  syscall

  #Read dividend n
  li $v0, 5
  syscall
  move $t0, $v0

  #Read divisor m
  li   $v0, 5 
  syscall
  move $t1, $v0
 
#Check for zero
check_zero_division:
  beq $t1, 0, zero_division
  j division

zero_division:
  li $v0, 4
  la $a0, error_message
  j exit

division:
  div $t0, $t1
  mflo $t2 #store quotient in register $t2 
  mfhi $t3 #store remainder in register $t3

display_quotient:
  li $v0, 4
  la $a0, q_message
  syscall
 
  li $v0, 1
  la $a0, ($t2)
  syscall
  
  li $v0, 4
  la $a0, new_line
  syscall


display_remainder:
  li $v0, 4
  la $a0, r_message
  syscall

  li $v0, 1
  la $a0, ($t3)
  syscall

exit:
  li $v0, 10
  syscall    

  