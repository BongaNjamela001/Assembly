.data                   #Declare memory and constants
    str:    .space 40   #Allocate 40 bytes to str
.text                   #Code section
.globl      main

#Program to show string IO
#Read n characters from the console
#Print the inputted characters to the conole

main:
    la      $a0, str        #Load address of str in $a0
    li      $v0, 8          #Load service 8 (reading strings)
    li      $a1, 5          #Max number of characters to read (including \0)
    syscall

    li		$v0, 4          #Load service 4 (printing strings)
    la      $a0, str
    syscall
    
exit:
    li		$v0, 10		    #Load service 10 (terminate program)
    syscall
    