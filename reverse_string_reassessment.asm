.data   #Declare memory and constants
    input_prompt:  .asciiz  "Enter string\n"
    fwd: .space 100
    rev: .space 100
.text
.globl  main

main:

    li  $v0, 4  #load service 4 for printing output
    la  $a0, input_prompt    #load the address of input prompt string to $a0
    syscall

    li  $v0, 8	#load service 8 for accepting input
    la	$a0, fwd #load address of fwd string to input
    li	$a1, 100 #maximum number of characters to read
    syscall

    la $t0, fwd
    move $t7, $t0 #beginning

find_end:
    lb   $t1, ($t0)             #load byte at start of register $t0
    beq  $t1, 10, end_find_end  #end of string at null pointer (=10)
    addi $t0, $t0, 1            #move to next byte address
    j find_end

end_find_end:
    addi $t0, $t0, -1
    la   $t2, rev		#load address of reserved space

loop:
    lb   $t1, (t0)
    sb   $t1, ($2)
    beq  $t0, $t7, end_loop
    addi $t0, $t0, -1
    addi $t2, $t2, 1
    j loop

end_loop:
    li   $v0, 4
    la   $a0, rev
    syscall

exit:
    li $v0,10
    syscall     