
section .data
    msg_hello db "Hello, world!",0x0A,0x00
    len_hello equ $-msg_hello

section .text
global _start
    _start:
        ; Print welcome message to the console
        mov rax,0x01
        mov rdi,0x01
        mov rsi,msg_hello
        mov rdx,len_hello
        syscall

        ; Exit the program
        mov rax,0x3C
        mov rdi,0x3C
        syscall
