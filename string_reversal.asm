.data
    input_prompt: .asciiz "Enter a string\n"
    string: .space 50
    string_rev: .space 50
.text
.globl main

main:
    li  $v0, 4
    la  $a0, input_prompt
    syscall

    li  $v0, 8
    la  $a0, string
    li  $a1, 50
    syscall

    la   $t0, string
    move $t7, $t0       #beginning

find_end:
    lb   $t1, ($t0)
    beq  $t1, 10, end_find_end
    addi $t0, $t0, 1
    j    find_end

end_find_end:
    addi  $t0, $t0, -1
    la    $t2, string_rev

loop:
    lb   $t1, ($t0)
    sb   $t1, ($t2)
    beq  $t0, $t7, end_loop
    addi $t0, $t0, -1
    addi $t2, $t2, 1
    j    loop

end_loop:
    li  $v0, 4
    la  $a0, string_rev
    syscall

exit:
    li  $v0, 10
    syscall