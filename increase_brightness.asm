.data
    input_image: .asciiz "/home/bonga/Documents/CSC2002S_2023/Assembly/input.ppm"
    output_image: .asciiz "/home/bonga/Documents/CSC2002S_2023/Assembly/output.ppm"
    lf: .asciiz "\n"
    buffer_in: .space 49200
    buffer_out: .space 49200
    ascii_out: .space 49200
    w: .word 64 #image width
    h: .word 64 #image height
    max_pixel_sum: .word 3133440
    errorMsg: .asciiz "Error. Could not open file."
    input_msg: .asciiz "Average pixel value of the original image:\n"
    output_msg: .asciiz "Average pixel value of new image:\n"
    max_brightness: .word 255 #brightest RGB value
    in_pixel_sum: .word 0 #sum total of all pixel vals
    out_pixel_sum: .word 0

.text                        #code section
.globl main                  

main:
    #reserve storage space for global variables 
    la $s1 buffer_in         #store input buffer address
    la $s2 in_pixel_sum      #store original pixel sum total address 
    la $s6 out_pixel_sum     #store new pixel sum total address
    la $s7 buffer_out        #store buffer for output file    
    la $t8 ascii_out         #store buffer for holding new ascii val
    la $t9 lf                #store lf in $t9   
    li $t0 0                 #file line counter
    
    #open image file
    li  $v0 13               #call service 13
    la  $a0 input_image      #load image address
    li  $a1 0                #read mode
    syscall                  #open file
    
    #throw error message
    bltz    $v0 error_message #could not open file
    move    $s0 $v0            #save file descriptor

    #read from file 
    li  $v0 14        #load service 14
    la  $a0 ($s0)     #load file descriptor address
    la  $a1 buffer_in #line buffer address
    li  $a2 49200     #maximum number of lines
    syscall
    
process_header:
    #Image file header has 4 lines
    #=============header=================
    #line 1: P3 (indicating color image)
    #line 2: File comments
    #line 3: 64 64 (width and height)
    #line 4: 255 maximum value possible
    lb   $t1 ($s1)              #load first line byte
    beq  $t0 4 pixel_processing #if we are done reading header
    bne  $t1 10 next_char       #if byte = 00001010 = "\n", end            
    sb   $s7 ($s1)              #store char byte in output buffer
    addi $s7 $s7 1              #increment output buffer address for next char
    addi $s1 $s1 1              #else buffer to next line
    addi $t0 $t0 1              #increase line number
    j process_header            #else jump to next line

next_char:      
    sb   $s7 ($s1)          #store char in buffer
    addi $s1 $s1 1          #else buffer to next line of input image
    addi $s7 $s7 1          #increment output buffer char address val
    j process_header

error_message:
    li $v0 4                    #service 4: print string
    la $a0 errorMsg             #load error message
    syscall                     #print error message

    j exit                      #close program

pixel_processing:
    #Convert ascii value to actual int val
    li $t5 0            #current int val
    li $s4 0            #brighter int val = current int val + 10
    jal ascii_to_int   #jump and link to ascii to int converter

    #add 10 to pixel val in $t5 to make it brighter
    addi $s4 $t5 10             #add 10 to pixel int R/G/B val
    add  $s2 $s2 $t5            #increase input pixels sum
    bgt  $s4 255 set_to_max     #if greater than 255, set to 255
 #   j 
    set_to_max:
        lw $s4 max_brightness   #set pixel int val to max

new_line:
    #append new line character (lf = "\n" in reg. $t9) to ascii  
    sb   $t9 ($t8)              #append new line "lf" ascii output buffer
    add  $s6 $s6 $s4            #add to pixel int val to total
    addi $t8 $t8 1              #go to next char address
    jal ascii_to_int            #convert to ascii and return to this instruct. address

new_pixel_ascii:
    #append pixel ascii value in buffer ($t8) to new image buffer
    addi $t8 $t8 -1             #get char address from ascii buffer using lifo    
    jal  compile_image

load_pixel:
    #retrieve all 12288 pixel, i.e. $t0_max=RGB val lines+header lines = 12288+4 = 12292
    addi $s1 $s1 1                  #get next char from input image
    bne  $t0 12292 pixel_processing #if not at file last line

    j write_image

compile_image:
    #append ascii values including lf to 
    lb   $t3 ($t8)                    #load ascii char byte to $t3
    sb   $t3 ($s7)                    #store char in output image buffer
    addi $s7 $s7 1                    #next address in image
    addi $t8 $t8 -1                   #previous char in file
    bne  $t3 10 output_image          #previous file
    jr   $ra                          #return to address

write_image:
    #open new ppm image file
    li $v0 13                         #for opening file
    la $a0 output_image               #reg. $a0 = address of new image ppm file
    li $a1 1                          #mode: write
    syscall                           #open image
    move $t4 $v0                      #store file descriptor
    
    #throw file not found exception
    bltz $v0 error_message

    #total number of ascii chars
    la   $t2 buffer_out               #add buffer address to reg. $t2
    sub  $t3 $s7 $t2                  #total number of ascii characters in new file
   
    #insert ascii in new image ppm file
    li   $v0 15                       #for writing to file
    move $a0 $t4                      #load file descriptor
    la   $a1 buffer_out               #load output buffer address
    move $a2 $t3                      #load reg. $t3 address into $a2
    syscall                           #print string

    jal close_new_image               #close image

original_average_prompt:
    #input image pixel average prompt message
    li $v0 4                     #for printing strings to console
    la $a0 input_msg             #load input message address to $a0
    syscall                      #print prompt to console

    jal calc_original_average    #calculate and print original image pixel average as float

new_average_prompt:
    #output image pixel average prompt message
    li $v0 4                     #for printing strings to console
    la $a0 output_msg            #load output message address to $a0
    syscall                      #print prompt to console

    jal calc_new_average         #calculate and print new image pixel average as float

    j exit                       #close program
#========================================================================================
#                               HELPER FUNCTIONS
#========================================================================================

ascii_to_int:
    li $t3 48                     #ascii val 48 := int val 0

    ascii_int_loop:
        lb $t1 ($s1)                    #$t1 = $s1:= pixel ascii value 
        addi $t0 $t0 1                  #increment line counter
        beq $t1 10 end_ascii_int_loop   #if end of line
        sub $s3 $t1 $t3                 #ascii - 48 = actual int value
        mul $t5 $t5 10                  #decimal place shifter to right by multiplying by 10
        add $t5 $t5 $s3                 #$t6 = $t6 + $s3 = tens + value
        addi $s1 $s1 1                  #go to next byte in pixel value
        j ascii_int_loop

    end_ascii_int_loop:        
        jr $ra                          #return 

int_to_ascii:
    div  $s4 $s4 10                      #divide int val by 10
    mfhi $s5                             #store remainder in $s5
    addi $s5 $s5 48                      #convert int val to ascii val by 48 zero offset
    sb   $s5 ($t8)                       #add ascii val in buffer
    addi $t8 $t8 1                       #go to next char address space in ascii buffer
    bnez $s4 int_to_ascii                #loop to complete int to ascii conversion
    jr   $ra                             #return address

calc_original_average:
    lw    $t2 max_pixel_sum              #load maximum possible RGB value sum
    mtc1  $s2 $f0                        #numerator = $s2 = input pixel sum
    mtc1  $t2 $f1                        #denominator = $t2
    div.s $f12 $f0 $f1                   #$s2/$t2
    li    $v0 2                          #for printing float in $f12
    syscall   
    jr $ra

calc_new_average:
    lw    $t2 max_pixel_sum              #load maximum possible RGB value sum
    mtc1  $s6 $f0                        #numerator = $s2 = output pixel sum
    mtc1  $t2 $f1                        #denominator = $t2
    div.s $f12 $f0 $f1                   #$s2/$t2
    li    $v0 2                          #for printing float in $f12
    syscall                              #print float in $f12
    jr $ra                               #jump back to

close_new_image:
    # use service 16 to close file
    li      $v0 16                         #for closing file
    move    $a0 $t4                        #load file descriptor
    syscall                                #close file
    jr $ra                                 #return to address

exit:
    li $v0 10   
    syscall     #close program
