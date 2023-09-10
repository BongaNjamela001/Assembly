.data       #Declare memory and constants
.text       #Code section
.globl      main

#Stack usage

main:
    li      $t1, 1
    li      $t2, 2
    li      $t3, 3

    addi    $sp, $sp, -12
    sw	    $t1, 8($sp)
    sw	    $t2, 4($sp)
    sw	    $t3, 0($sp)

    li      $t1, 0
    li      $t2, 0
    li      $t3, 0

    lw	    $t3, 0($sp)
    lw	    $t2, 4($sp)
    lw	    $t1, 8($sp)
    addi	$sp, $sp, 12

exit:
    li		$v0, 10
    syscall
