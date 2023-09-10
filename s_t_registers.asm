.data
    output_message: .asciiz "Function B is executing\n"
.text
.globl main

#High level view:
#void A()
#{
#   int i = 5;
#   int j = 6;
#   int k = i + j;
#   int l = i - j;
#   B();
#   i = k;
#   l = j;
#}
#
#B()
#{
#    int p = 10;
#    int q = 11;
#    System.out.println("Function B is executing");
#}

main:
    j		A				# jump to A

A:
    li		$t0, 5          #Load the immediate 5 into $t0
    li		$t1, 6          #Load the immediate 6 into $t1
    add		$s0, $t0, $t1   #Add $t0 and $t1, and place the result in $s0
    sub		$s1, $t0, $t1	#Sub $t0 and $t1, and place the result in $s1

    addi	$sp, $sp, -8	#The call to B is approaching. Since A is the caller function it must save the state of its T registers, by pushing their values to stack. The order in which register values are pushed to stack does not matter, but it is up to you to remember which register values lie at which locations in stack memory.
    sw		$t1, 4($sp)     #Generally, you would only save register values to memory if you want to use those values again after the callee function has returned (the value in $t0 is not used in A after B returns so there isn't a need to save it).
    sw		$t0, 0($sp)     #However, for this example, we will save $t0 as well.

    jal		B				#Jump to B and save the value of PC+4 (which will be the address of the instruction immediately following this) to $ra

    lw		$t0, 0($sp)     #Since the previous instruction was a jump and link, the only way this line could be reached is if the callee function returns.
    lw		$t1, 4($sp)     #A needs to restore the state of its T registers, by popping them from stack.
    addi	$sp, $sp, 8

    move 	$t0, $s0		#Move the value in $s0 to $t0 ($s0 will not change)
    move    $s1, $t1        #Move the value in $t1 to $s1 ($t1 will not change)
    
B:
    addi	$sp, $sp, -8	#This is the beginning of the B function in the high level view.
    sw		$s1, 4($sp)     #Since S registers are guaranteed to contain the same values before and after a function call, B must save the current state of the S registers to memory, since it will change them.
    sw		$s0, 0($sp)

    li		$t0, 10         #Load the immediate 10 into $t0
    li		$s0, 11         #Load the immediate 11 into $s0
    
    li		$v0, 4		        #Load the immediate 4 into $v0 (request service 4 - print string)
    la		$a0, output_message #Load the address of the string to print
    syscall                     #Perform syscall

    lw		$s0, 0($sp)     #B is ending and will return to A
    lw		$s1, 4($sp)     #Since B has changed the values in S registers, it must restore this by popping them from stack
    addi	$sp, $sp, 8

    jr		$ra				#Jump to $ra

exit:
    li		$v0, 10         #Load the immediate 10 into $v0 (request service 10 - terminate program)
    syscall                 #Perform syscall
        