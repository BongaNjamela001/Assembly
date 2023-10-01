.data
    input_image: .asciiz "/home/bonga/Documents/CSC2002S_2023/Assembly/input.ppm"
    output_image: .asciiz "/home/bonga/Documents/CSC2002S_2023/Assembly/output.ppm"
    lf: .asciiz "\n"
    buffer: .word 49200
    w: .word 64 #image width
    h: .word 64 #image height
    original_avg: .float 1.414
    new_avg: .float 1.414
    errorMsg: .asciiz "Error. Could not open file."
    max_color: .word 255

.text
.globl main

main:
    la $s1 buffer            #save buffer address

    # open image file
    li  $v0 13               #call service 13
    la  $a0 input_image      #load image address
    li  $a1 0                #read mode
    syscall                  #open file
    
    #throw error message
    bltz    $v0 error_message #could not open file
    move    $s0 $v0            #save file descriptor

    #read from file 
    li      $v0 14      #load service 14
    la      $a0 ($s0)     #load file descriptor address
    la      $a1 buffer  #line buffer address
    li      $a2 49200   #maximum number of lines
    syscall



    bltz    $v0 close_image
    
    li $t0 0 #header line counter

skip_header:
    #Image file header has 4 lines
    #=============header=================
    #line 1: P3 (indicating color image)
    #line 2: File comments
    #line 3: 64 64 (width and height)
    #line 4: 255 maximum value possible
    lb   $t1 ($s1)          #load first line byte
    beq  $t0 4 brighter     #if we are done reading header
    bne  $t1 10 line_number #if byte = 10 = "\n", end            
    addi $s1 $s1 1          #else buffer to next line
    j skip_header           #else jump to next line

line_number:      
        addi $t0 $t0 1         #increase line number
        j skip_header

error_message:
    li $v0 4                    #service 4: print string
    la $a0 errorMsg             #load error message
    syscall                     #print error message

    j exit                      #jump to close programs

brighter:

    j exit
asciiz_to_int:
    li $t3 48

    j exit
int_to_ascii:
    j exit
close_image:
    # use service 16 to close file
    li      $v0 16                         #load service 16
    move    $a0 $s0                        #file descriptor
    syscall

exit:
    li $v0 10
    syscall     #close program
