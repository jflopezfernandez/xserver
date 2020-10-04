;-----------------------------------------------------------
;
;                       main.asm
;
;-----------------------------------------------------------
;
; Author:
;
;       Jose Fernando Lopez Fernandez
;
; Date Created:
;
;       October 3, 2020
;
; Date Last Updated:
;
;       October 4, 2020 [05:09:09 PM EDT]
;
; Description:
;
;       This is the primary source file for the xserver web
;       server.
;
;-----------------------------------------------------------

                CPU X64

                SECTION .data
   
newline: db 0x0A

msg_hello: db "Hello, world!",0x0A,0x00
len_hello: equ $-msg_hello

msg_no_input: db "[Error] No input(s).",0x0A,0x00
len_no_input: equ $-msg_no_input

                SECTION .bss

server_socket: resb 4

                SECTION .text
                GLOBAL _start

_start:

        ; Preserve the stack frame
        push rbp
        mov rbp,rsp

        ; Check whether any command-line arguments were passed in
        mov rcx,[rbp+8]
        cmp rcx,1
        jnz .args_ok

        ; Display error message
        mov rax,0x01
        mov rdi,0x01
        mov rsi,msg_no_input
        mov rdx,len_no_input
        syscall

        ; Restore the stack frame
        mov rsp,rbp
        pop rbp

        ; Exit with error code
        mov rax,0x3C
        mov rdi,0x01
        syscall

.args_ok:

        ; Foreach arg in args:
        ;     print arg
        ;     print newline
        ; Exit

        ; Iterate over the arguments
        ; rcx <- argc
        mov rcx,0x01

.print_arg:

        ; The value of the rcx register is not preserved
        ; between function calls, so we preserve the current
        ; value by pushing it on to the stack prior to
        ; invoking the kernel via syscall.
        ;
        push rcx

        ; Calculate the length of the current argument
        xor r11,r11

    .next_char:
        mov r8,[rbp+16+8*rcx]
        mov r9b,[r8 + r11]
        cmp r9,0x00
        je .end_of_string
        inc r11
        jmp .next_char
    
    .end_of_string:

        ; Print the command-line argument
        mov rax,0x01
        mov rdi,0x01
        mov rsi,[rbp+16+8*rcx]
        mov rdx,r11
        syscall

        ; Print a newline character
        mov rax,0x01
        mov rdi,0x01
        mov rsi,newline
        mov rdx,0x01
        syscall

        ; Restore the stack and our loop counter by popping
        ; the top value back off the stack and into the rcx
        ; register.
        ;
        pop rcx

        ; Increment the loop counter
        inc rcx
        cmp rcx,[rbp+8]
        jnz .print_arg
        
        ; Restore the stack frame
        mov rsp,rbp
        pop rbp

        ; Exit with success status code
        mov rax,0x3C
        xor rdi,rdi
        syscall

        ; --------------------------------------------------

        ; Preserve the number of command-line arguments
        mov rcx,[rbp+8]

        ; Print the first argument
        mov rax,0x01
        mov rdi,0x01
        mov rsi,[rbp+16]
        mov rdx,52
        syscall

        ; Print a newline
        mov rax,0x01
        mov rdi,0x01
        mov rsi,newline
        mov rdx,0x01
        syscall

        ; Print welcome message
        mov rax,0x01
        mov rdi,0x01
        mov rsi,msg_hello
        mov rdx,len_hello
        syscall

        ; Print a newline
        mov rax,0x01
        mov rdi,0x01
        mov rsi,newline
        mov rdx,0x01

        ; Restore the stack frame
        mov rsp,rbp
        pop rbp

        ; DEBUG: Early exit
        mov rax,0x3C
        xor rdi,rdi
        syscall

        ; Preserve the rbp and rsp register contents
        push rbp
        mov rbp,rsp

        ; Restore the rbp and rsp register contents
        mov rsp,rbp
        pop rbp
        
        ; Early return, skipping all original code for now.
        mov rax,0x3C
        ;xor rdi,rdi
        syscall

        ; Print welcome message to the console
        mov rax,0x01
        mov rdi,0x01
        mov rsi,msg_hello
        mov rdx,len_hello
        syscall

        ; Create a socket           net/socket.c
        mov rax,0x29 ; socket
        mov rdi,0x02 ; AF_INET      include/linux/socket.h
        mov rsi,0x01 ; SOCK_STREAM  include/linux/net.h
        ;mov rdx,0x06 ; TCP          /etc/protocols
        mov rdx,0x00
        syscall

        ; TODO: Check for error

        ; Assign the file descriptor to the server socket
        mov [server_socket],eax

        ; TODO: Call bind()
        ;
        ; int bind(int sockfd, const struct sockaddr* addr, socklen_t addrlen)
        ;
        ;


        ; TODO: Check for error

        ; Start server listener socket
        mov rax,0x32 ; SYSCALL_LISTEN
        mov rdi,[server_socket]
        mov rsi,0x0A
        syscall

        ; TODO: Check for error

        ; Exit the program
        mov rax,0x3C
        xor rdi,rdi
        syscall
