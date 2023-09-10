.data                   #Declare memory and constants
    num1:   .word       12
    num2:   .word       13
    num3:   .word       14
    num4:   .word       15
    num5:   .word       16
    num6:   .word       17
    num7:   .word       18
.text                   #Code section

#Program that loads words from memory and stores words to memory

li          $t4, 5

main:    
    la      $t4, num1       #Load address of num1 to temp register $t4
    la      $t5, num5       #Load address of num5 to $t5
    lw      $t1, num1       #Load value of num1 to $t1
    lw      $t2, num2       #Load value of num2 to $t2
    add		$t3, $t1, $t2	#$t3 = $t1 + $t2
    sw      $t3, num3       #Store the value in $t3 in num3
    
exit:
    li		$v0, 10		    #Load service 10 (terminate program)
    syscall
    