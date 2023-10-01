.data       #Declare memory and constants
.text       #Code section
# .globl      main

# if ($s0 == $t0)
# {
#       $v0 = $t5 + $s6;
# }
# elsec
# {
#       $v0 = $t5 - $s6;
# }

main:
    li		$s0, 20
    li      $t0, 20
    li      $t5, 5
    li      $s6, 6

IF:
    bne		$s0, $t0, ELSE
    add     $t7, $t5, $s6
    li $v0, 1
    move $a0, $t7
    syscall
    j		EXIT                    #Jump to EXIT to avoid running the ELSE label

ELSE:
    sub		$t7, $t5, $s6

EXIT:
    li		$v0, 10		#v0 =10 
    syscall
