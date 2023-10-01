.data				#Declare memory and constants
    input_prompt: .asciiz "Enter three lines of text:\n"
    output_heading: .asciiz "The lines reversed are:\n"
    str1: .space 100
    str2: .space 100
    str3: .space 100
.text				#code section
.globl main

main:
    li	$v0, 4	#Load service 4 for printing to console
    la  $a0, input_prompt
    syscall

    li  $v0, 8
    la  $a0, str1
    li  $a1, 100
    syscall
    
    la  $t1, str1
    
    li  $v0, 8
    la  $a0, str2
    li  $a1, 100
    syscall
 
    la  $t2, str2
    
    li  $v0, 8
    la  $a0, str3
    li  $a1, 100
    syscall

    la  $t3, str3

start_printing:
    li $v0, 4
    la $a0, output_heading
    syscall

print_3:
    li   $v0, 4
    la   $a0, ($t3)
    syscall

print_2:
    li   $v0, 4
    la   $a0, ($t2)
    syscall

print_1:
    li   $v0, 4
    la   $a0, ($t1)
    syscall

exit:
    li $v0, 10
    syscall         