.data                   #Declare memory and constants
    arr1:   .word   10, 20, 30, 40, 50,
    arr2:   .space  80
.text                   #Code section
.globl main

#Program that loads words from memory and stores words to memory using offsets.

main:    
    la      $t0, arr1       #Load address of arr1 in $t0
    lw      $t1, ($t0)      #Load value of address(arr1+0) in $t1
    lw      $t2, 4($t0)     #Load value of address(arr1+4) in $t2
    lw      $t3, 8($t0)     #Load value of address(arr1+8) in $t3
    lw      $t4, 12($t0)    #Load value of address(arr1+12) in $t4
    lw      $t5, 16($t0)    #Load value of address(arr1+16) in $t5

    addi	$t1, $t1, 1		#$t1 = $t1 + 1
    addi	$t2, $t2, 1
    addi	$t3, $t3, 1
    addi	$t4, $t4, 1
    addi	$t5, $t5, 1

    la      $s0, arr2
    sw      $t1, ($s0)      #Store value of  in $t1 address(arr1+0)
    sw      $t2, 4($s0)
    sw      $t3, 8($s0)
    sw      $t4, 12($s0)
    sw      $t5, 16($s0)

    lw      $s1, ($s0)
    lw      $s2, 4($s0)
    lw      $s3, 8($s0)
    lw      $s4, 12($s0)
    lw      $s5, 16($s0)
    
exit:
    li		$v0, 10		    #Load service 10 (terminate program)
    syscall
