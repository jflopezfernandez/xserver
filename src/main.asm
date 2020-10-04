
section .data
    msg_hello db "Hello, world!",0x0A,0x00
    len_hello equ $-msg_hello

section .bss
    server_socket resb 4

section .text
global _start
    _start:
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
