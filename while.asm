.data       #Declare memory and constants
array:   .word 1, 2, 3, 4, 5, 6, 7
.text       #Code section
.globl      main

# while (array[i] < n)

main:
    li		$s5, 5		#n = 5
    la      $s6, array
    move    $s3, $zero
    

loop: 
    sll     $t1, $s3, 2 #convert i to byte addr
    add     $t1, $t1, $s6 #array element addr
    lw      $t0, 0($t1) #deref array
    bge     $t0, $s5, exit #check loop end
    addi    $s3, $s3, 1
    j loop
    
exit:
    li		$v0, 10
    syscall
