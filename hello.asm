.data                   #Declare memory and constants
    hello:  .asciiz     "Hello world"
.text                   #Code section
.globl      main        #Start program at label main

#Program that prints "Hello world" from memory

main:    
    la      $a0, hello      #Load address of hello in $a0
    li      $v0, 4          #Load service 4 (print strings)
    syscall
    
exit:
    li		$v0, 10		    #Load service 10 (terminate program)
    syscall
    