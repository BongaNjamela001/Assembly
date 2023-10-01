.data
input_image:    .asciiz "input.ppm"   # Input PPM file name
output_image:   .asciiz "output.ppm"  # Output PPM file name
width:          .word 64             # Image width
height:         .word 64             # Image height
max_color:      .word 255            # Maximum color value

.text
.globl main

main:
    # Open the input image for reading
    li $v0, 13
    la $a0, input_image
    li $a1, 0  # File mode: read
    syscall
    move $s0, $v0  # File descriptor

    # Read and parse the PPM header
    li $t0, 0
    header_loop:
        li $v0, 14
        move $a0, $s0
        lb $a1, ($t0)
        syscall

        # Check for the end of the header (newline)
        beq $a1, 10, header_done  # ASCII code 10 for newline
        addi $t0, $t0, 1
        j header_loop

    header_done:
    # Load image dimensions and max color value
    lw $t1, width
    lw $t2, height
    lw $t3, max_color

    # Initialize counters for RGB sums
    li $t4, 0  # Red sum
    li $t5, 0  # Green sum
    li $t6, 0  # Blue sum

    # Loop through the image to read RGB values
    image_loop:
        # Read R, G, and B values for a pixel
        li $v0, 14
        move $a0, $s0
        lb $a1, ($t4)
        lb $a2, 1($t4)
        lb $a3, 2($t4)
        syscall

        # Increase RGB values by 10 (max limit is 255)
        addi $a1, $a1, 10
        addi $a2, $a2, 10
        addi $a3, $a3, 10

        # Check if the values exceed 255
        li $t7, 255
        sub $a1, $a1, $t7
        sub $a2, $a2, $t7
        sub $a3, $a3, $t7

        # Write the modified RGB values for the pixel
        li $v0, 15
        move $a0, $s1
        move $a1, $a1
        move $a2, $a2
        move $a3, $a3
        syscall

        # Continue with the next pixel
        addi $t4, $t4, 3

         # Check if we've processed all pixels
        addi $t1, $t1, -1
        bnez $t1, image_loop_modified  # If there are more rows

        addi $t2, $t2, -1
        beqz $t2, calculate_average  # If all rows are processed

        # Skip to the next row (newline character)
        li $v0, 14
        move $a0, $s1
        lb $a1, ($t4)
        syscall

        # Reset the column counter and continue to the next row
        li $t1, 64
        j image_loop_modified

    end_of_image:
    # Calculate the average RGB values for the modified image
    # Reset counters for RGB sums
    li $t4, 0  # Red sum
    li $t5, 0  # Green sum
    li $t6, 0  # Blue sum

    # Seek back to the beginning of the modified image file
    li $v0, 16
    move $a0, $s1
    li $a1, 0
    syscall

    # Loop through the modified image to calculate the sums
    image_loop_modified:
        # Read R, G, and B values for a pixel
        li $v0, 14
        move $a0, $s1
        lb $a1, ($t4)
        lb $a2, 1($t4)
        lb $a3, 2($t4)
        syscall

        # Continue with the next pixel
        addi $t4, $t4, 3

        # Check if we've processed all pixels
        addi $t1, $t1, -1
        bnez $t1, image_loop_modified  # If there are more rows

        addi $t2, $t2, -1
        beqz $t2, calculate_average  # If all rows are processed

        # Skip to the next row (newline character)
        li $v0, 14
        move $a0, $s1
        lb $a1, ($t4)
        syscall

        # Reset the column counter and continue to the next row
        li $t1, 64
        j image_loop_modified

    calculate_average:
    # Calculate the average RGB values for the modified image
    li $v0, 0
    move $a0, $t4
    li $a1, 64
    syscall
    l.d $f1, ($a0)  # Load the result into $f1

    li $v0, 0
    move $a0, $t5
    li $a1, 64
    syscall
    l.d $f2, ($a0)  # Load the result into $f2

    li $v0, 0
    move $a0, $t6
    li $a1, 64
    syscall
    l.d $f3, ($a0)  # Load the result into $f3

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
