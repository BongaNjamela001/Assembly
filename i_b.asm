.data
original_image:  .asciiz "house_64_in_ascii_lf.ppm"  # Specify the input PPM file name
modified_image:  .asciiz "output.ppm"  # Output PPM file name
width:           .word 64             # Image width
height:          .word 64             # Image height
max_color:       .word 255            # Maximum color value

.text
.globl main

main:
    # Open the original image for reading
    li $v0, 13
    la $a0, original_image
    li $a1, 0  # File mode: read
    syscall
    move $s0, $v0  # File descriptor

    # Open the modified image for writing
    li $v0, 13
    la $a0, modified_image
    li $a1, 1  # File mode: write
    syscall
    move $s1, $v0  # File descriptor

    # Load image dimensions and max color value
    lw $t0, width
    lw $t1, height
    lw $t2, max_color

    # Initialize counters for RGB sums
    li $t3, 0  # Red sum
    li $t4, 0  # Green sum
    li $t5, 0  # Blue sum

    # Loop through the image
    image_loop:
        # Read a pixel (3 bytes: R, G, B)
        li $v0, 14
        move $a0, $s0
        la $a1, ($t3)  # Address for R
        la $a2, ($t4)  # Address for G
        la $a3, ($t5)  # Address for B
        syscall

        # Increase RGB values by 10 (max limit is 255)
        addi $t3, $t3, 10
        addi $t4, $t4, 10
        addi $t5, $t5, 10
        li $t6, 255
        sub $t3, $t3, $t6
        sub $t4, $t4, $t6
        sub $t5, $t5, $t6

        # Write the modified pixel
        li $v0, 15
        move $a0, $s1
        la $a1, ($t3)  # Address for R
        la $a2, ($t4)  # Address for G
        la $a3, ($t5)  # Address for B
        syscall

        # Continue with the next pixel
        addi $t3, $t3, 3
        addi $t4, $t4, 3
        addi $t5, $t5, 3

        # Check if we've processed all pixels
        bne $t3, $t0, image_loop
        bne $t4, $t0, image_loop

    # Calculate the average RGB values for the original image
    li $v0, 0   # Initialize the average value
    move $a0, $t3
    li $a1, 64  # Number of pixels
    syscall
    l.d $f0, ($a0)  # Load the result into $f0

    li $v0, 0
    move $a0, $t4
    li $a1, 64
    syscall
    l.d $f2, ($a0)  # Load the result into $f2

    li $v0, 0
    move $a0, $t5
    li $a1, 64
    syscall
    l.d $f4, ($a0)  # Load the result into $f4

    # Calculate the average RGB values for the modified image
    # Reset counters for RGB sums
    li $t3, 0
    li $t4, 0
    li $t5, 0

    # Seek back to the beginning of the modified image file
    li $v0, 16
    move $a0, $s1
    li $a1, 0
    syscall

    # Loop through the modified image to calculate the sums
    image_loop_modified:
        li $v0, 14
        move $a0, $s1
        la $a1, ($t3)  # Address for R
        la $a2, ($t4)  # Address for G
        la $a3, ($t5)  # Address for B
        syscall

        # Continue with the next pixel
        addi $t3, $t3, 3
        addi $t4, $t4, 3
        addi $t5, $t5, 3

        # Check if we've processed all pixels
        bne $t3, $t0, image_loop_modified
        bne $t4, $t0, image_loop_modified

    # Calculate the average RGB values for the modified image
    li $v0, 0
    move $a0, $t3
    li $a1, 64
    syscall
    l.d $f1, ($a0)  # Load the result into $f1

    li $v0, 0
    move $a0, $t4
    li $a1, 64
    syscall
    l.d $f3, ($a0)  # Load the result into $f3

    li $v0, 0
    move $a0, $t5
    li $a1, 64
    syscall
    l.d $f5, ($a0)  # Load the result into $f5

    # Display the average RGB values
    li $v0, 4
    la $a0, original_avg
    syscall
    li $v0, 3
    l.d $f12, ($f0)
    syscall

    li $v0, 4
    la $a0, modified_avg
    syscall
    li $v0, 3
    l.d $f12, ($f1)
    syscall

    # Exit
    li $v0, 10
    syscall
