.data
input_image:    .asciiz "input.ppm"   # Input PPM file name
output_image:   .asciiz "output.ppm"  # Output PPM file name

.text
.globl main

main:
    # Open the input image for reading
    li $v0, 13
    la $a0, input_image
    li $a1, 0  # File mode: read
    syscall
    move $s0, $v0  # File descriptor

    # Open the output image for writing
    li $v0, 13
    la $a0, output_image
    li $a1, 1  # File mode: write
    syscall
    move $s1, $v0  # File descriptor

    # # Buffer for reading and writing pixel data
    # buffer: .space 9

    # # Loop to read, modify, and write the image
    # copy_loop:
    #     # Read a line from the input image
    #     li $v0, 14
    #     move $a0, $s0
    #     la $a1, buffer
    #     li $a2, 9
    #     syscall

    #     # Convert ASCII RGB values to integers
    #     li $t0, 0
    #     li $t1, 0
    #     li $t2, 0
    #     la $t3, buffer

    #     # Convert the red value
    #     lb $t4, 0($t3)
    #     lb $t5, 1($t3)
    #     lb $t6, 2($t3)
    #     li $t7, 48  # ASCII '0'
    #     sub $t4, $t4, $t7
    #     sub $t5, $t5, $t7
    #     sub $t6, $t6, $t7
    #     mul $t8, $t4, 100
    #     mul $t9, $t5, 10
    #     add $t0, $t8, $t9
    #     add $t0, $t0, $t6

    #     # Convert the green value
    #     lb $t4, 3($t3)
    #     lb $t5, 4($t3)
    #     lb $t5, 5($t3)
    #     sub $t4, $t4, $t7
    #     sub $t5, $t5, $t7
    #     sub $t6, $t6, $t7
    #     mul $t8, $t4, 100
    #     mul $t9, $t5, 10
    #     add $t1, $t8, $t9
    #     add $t1, $t1, $t5

    #     # Convert the blue value
    #     lb $t4, 6($t3)
    #     lb $t5, 7($t3)
    #     lb $t6, 8($t3)
    #     sub $t4, $t4, $t7
    #     sub $t5, $t5, $t7
    #     sub $t6, $t6, $t7
    #     mul $t8, $t4, 100
    #     mul $t9, $t5, 10
    #     add $t2, $t8, $t9
    #     add $t2, $t2, $t6

    #     # Add 10 to the RGB values
    #     addi $t0, $t0, 10
    #     addi $t1, $t1, 10
    #     addi $t2, $t2, 10

    #     # Ensure that values do not exceed 255
    #     li $t3, 255
    #     bgt $t0, $t3, clamp_red
    #     bgt $t1, $t3, clamp_green
    #     bgt $t2, $t3, clamp_blue

    #     # Convert the modified RGB values back to ASCII
    #     li $t4, 10  # ASCII '0' + 10
    #     add $t4, $t0, $t4
    #     add $t5, $t1, $t4
    #     add $t6, $t2, $t4

    #     # Write the modified RGB values to the buffer
    #     sb $t4, 0($t3)
    #     sb $t5, 1($t3)
    #     sb $t6, 2($t3)

    #     # Write the modified line to the output image
    #     li $v0, 15
    #     move $a0, $s1
    #     la $a1, buffer
    #     li $a2, 9
    #     syscall

    #     j copy_loop

    # clamp_red:
    #     li $t0, 255
    #     j write_clamped

    # clamp_green:
    #     li $t1, 255
    #     j write_clamped

    # clamp_blue:
    #     li $t2, 255

    # write_clamped:
    #     # Convert clamped values back to ASCII
    #     li $t3, 10  # ASCII '0' + 10
    #     add $t4, $t0, $t3
    #     add $t5, $t1, $t3
    #     add $t6, $t2, $t3

    #     # Write the clamped line to the output image
    #     la $t3, buffer
    #     sb $t4, 0($t3)
    #     sb $t5, 1($t3)
    #     sb $t6, 2($t3)

    #     li $v0, 15
    #     move $a0, $s1
    #     la $a1, buffer
    #     li $a2, 9
    #     syscall

    #     j copy_loop

exit:
    li $v0, 10
    syscall