; Executable name : STACK 
; Version         : 1.0 
; Created date    : 4/25/2025
; Last Updated    : 4/25/2025
; Author          : Paschal Ahanmisi 
; Architecture    : x64 
; From            : Assembly language programming 
; Description     : A simple program in  showing poping and pushing to the stack for beginners 
; Make sure to use a debugger to read the values of the registers as you observe the code 
SECTION .bss ; section contains the uninitialed data 
SECTION .data ; section contains the initialized data
SECTION .text ; section contains code 
    global _start 
_start : 
    ;mov rax , 23 ; move 23 to the rax register 
    ;mov rdx , 233; moving rdx to 233;
    ;push rax ; pushb 64 bit to the rax register 
    ;push rdx ;
    ;mov rcx , [rsp+8]
    ;--- syscall ot exit ---; 
    ; mov rax , 60; sys_exit call 
    ; mov rdi, 0; exit with 0 value 
    ; syscall ; syscall to exit 
    xor rax , rax ; We first zero out all 4 64 bit register "x registers "
    xor rbx, rbx ; 
    xor rcx , rcx ;
    xor rdx , rdx 

    ;-----Places values in AX, BX and CX------------
    mov ax, 0x1234; placing values in the registers 
    mov bx , 0x4ba7;
    mov cx , 0xff17; moving hex value to register 

    ; --- Pushing to the stack----
    push ax ; pushing ax to stack 
    push bx ; pushing bx to stack 
    push cx ; pushing cx to the stack 

    pop dx ; pops the cx to this value 
    ; I recommened using GDB debugger to peak through the values of the register 

    ; syscall to exit to aviod segmentation fault when runnning the script 
    ;--- syscall ot exit ---; 
     mov rax , 60; sys_exit call 
     mov rdi, 0; exit with 0 value 
     syscall ; syscall to exit 

