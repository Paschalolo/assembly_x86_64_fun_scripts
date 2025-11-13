; Executable name : STACK 
; Version         : 1.0 
; Created date    : 4/25/2025
; Last Updated    : 4/25/2025
; Author          : Paschal Ahanmisi 
; Architecture    : x64 
; From            : Assembly language programming 
; Description     : A simple program in  showing poping and pushing to the stack for beginners 
; Make sure to use a debugger to read the values of the registers as you observe the code 

SECTION .data ; section to store the initialized data 
SECTION .bss ; section to store the uninitialized data 
    Buff:  resb 1 
SECTION .text ; section to store the code 
    global _start ; used to show where the linker is going to start at 
_start : 
    mov rbp, rsp; for correct debbuging 
Read: 
    mov rax , 0; specify sys_read call 
    mov rdi , 0 ; specify file discriptor to read from Standard Input 
    mov rsi , Buff; Pass the address opf the buffer to read charcter to 
    mov rdx ,1 ; Tell sys_read to read one char from stdin 
    syscall ; call sys_read

    cmp rax , 0 ; look at sysread return  value in RAX 
    je Exit; Jump If equal to 0 means (0 means EOF) to Exit 
            ; Or fall through to test for lower values 
    cmp byte [Buff] , 0x61; Test inputs char against lowercase 'a'
    jb Write ;if below 'a ' in ASCII char , not lowercase 
    cmp byte [Buff] , 0x7A; Test inputs char against lowercase 'z'
    ja Write; if above 'z' it is not lowercase 

    sub byte[Buff] , 0x20; substract from lowercase to give upper case ;
                         ; and then write out char to stdout 
Write:  
    mov rax, 0x01; call the sys_write sysytem call 
    mov rdi, 1; specify the stdout to write to stdout ; terminal screen
    mov rsi , Buff; Pass the address of the buffer to read character to 
    mov rdx ,1 ; Tell sys_read to read one char from stdin 
    syscall ; call sys_read
    jmp Read; Then go to the beginning to get another char 
Exit : 
    ret ; return End of Program 

