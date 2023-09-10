.data                       # Declare memory and constants
    num1:   .word       12  # creates a 4-byte memory word 
    num2:   .word       13
    num3:   .word       0
.text                   # Code section
.globl      main        # Start program at the label 'main'
# Program loads words from memory and stores words to memory
main:
    lw      $t1, num1        # load number 12 to temp register $t0
    lw      $t2, num2        # load number 13 to temp register $t1
    add     $t3, $t1, $t2    # $t3 = $t2 + $t3
    sw      $t3, num3        # store the value in $t3 to the register num3

exit:
    li      $v0, 10          # load service 10 (terminate program)
    syscall