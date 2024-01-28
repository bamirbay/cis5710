        .section .data
input_string:   .asciz "Hello World!"

        # tohost/fromhost are data locations used by Spike
        .align 8
tohost: .byte 0
        .align 8
fromhost: .byte 0

        
        .section .text
        .globl _start
_start:
        # Load the address of the input string into a0
        la a0, input_string
        li a2, 96
        li a3, 122


loop:
        # Load value at a0
        lb a1, 0(a0)

        # If 0 (NUL) end program
        beqz a1, end_program

        # Check for lower case letter: if not, go to next character
        bleu a1, a2, increment
        bgtu a1, a3, increment

        # Set lower case to upper case
        addi a1, a1, -32

        # Set memory value at a0 to new a1
        sb a1, 0(a0)

increment: 
        addi a0, a0, 1
        j loop
        
end_program:
        # jump here when you're done
        j end_program

