
section .text
global _start
    _start:
        mov rax,0x3C
        mov rdi,0x3C
        syscall
