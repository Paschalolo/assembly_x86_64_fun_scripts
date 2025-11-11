; Executable name : EATSYSCALLNAME 
; Version         : 1.0 
; Created date    : 4/25/2025
; Last Updated    : 4/25/2025
; Author          : Paschal Ahanmisi 
; Architecture    : x64 
; From            : Assembly language programming 
; Description     : A simple program in  assembly for x64 linux using NASM display text. 


; Build using these commands 
;   nasm -f elf64 -g -F stabs eatsyscall.asm 
;   ld -o eatsyscall eatsyscall.o
; 
;

SECTION .data ; section containing initialized data 
SECTION .bss  ; section containing uniniialized data 
    ; Reserve 16 bytes in the .bss (uninitialized data) section for our input
    input_buffer: resb 16
SECTION .text ; section containing code 
    global _main ; linker needs this to find the entry point 
_main : 
    ; ---- syscall read from keyboard input------
    mov rbp, rsp ; for correct debugging 
    nop ; This no-op keeps gdb happy 
    mov rax , 0 ; 0 = sys_read for syscall
    mov rdi , 0 ; read from stdin i.e Keybopard input 
    mov rsi , input_buffer ; buffer to store data 
    mov rdx ,13; move only 10 stuff from the char bufer 
    syscall ; syscall to call the function in kernel


    ;  ----------- syscall to write to output buffer i.e moniotor ----------

    mov rax , 1 ; 1 = sys_write for syscall
    mov rdi , 1 ; write to stdout  i.e monitor  inpu 
    mov rsi , input_buffer ; buffer to store data 
    mov rdx , 13; read 13 butes from the buffer 
    syscall 

     ; ------Exit system call ----
    mov rax , 60; 60 = exit the program 
    mov rdi, 0 ; Return value in rdi = 0 = nothing to return 
    syscall ; Call syscall to exit  

