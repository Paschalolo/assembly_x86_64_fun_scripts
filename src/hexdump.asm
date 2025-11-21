; Executable name : hecdump1gcc 
; Version : 2.0 
; Created Date : 5/9/22
; Last Updated : 5/9/22
; Author : Paschal Ahanmisi
; A simple program Converting binary to hexaadecimal strings 
;
;
;
; Run it this way : 
; hexdump < (input file)


SECTION .bss ; Sectiton containing uninitialized data 
    BUFFLEN equ 16 ; we read the file 16 bytes at a time 
    Buff : resb BUFFLEN ; Text buffer itself , reserve 16 bytes 
SECTION .data ; section containing initialized data 
    HexStr: db "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00",10
    HEXLEN equ $-HexStr
    Digits : db "0123456789ABCDEF"
Section .text  ; Section containing code 
    global _start ; Main route for linker to know where to start 

_start : 
     mov rbp , rsp ; For the debugger 
    ; Read a buffer Full of text 
Read:
    mov rax , 0 ; specify syscal for read 
    mov rdi , 0; File discriptor for standard input 
    mov rsi , Buff; Pass offset of the buffer to read to 
    mov rdx , BUFFLEN; Pass number of bytes to read at one pass 
    syscall ; call sys_read to fill the buffer 
    mov r15, rax ; save # of bytes read from file for later 
    cmp rax , 0 ; if rax = 0  , sys_read has reached EOF on stdin 
    je Done ; Jump if equal to done 

    ; set up registers for the process buffer step : parm 
    mov rsi , Buff ; place address of file buffer into esi 
    mov rdi, HexStr ; place address of line string into edi 
    xor rcx, rcx ; clear line string pointer to 0 

    ; Go through the buffer and convert binary values to hex digits : 
Scan :
    xor rax, rax ; clear rax to 0 

    ;Here we calculate the offset into the line string , whihc rcx X 3 
    mov rdx,rcx ; Copy the pointer into line string into rdx 
    ; shl edx ,1 ; Multiply pointer by 2 using left shifts 
    ; add rdx ,rcx ; Complete multiplication X3 
    lea rdx , [rdx*2+rdx] ; This does what the above two lines do !
    ; See discussion of lEA later 
; Get a chracter from the buffer and put it in both rax and rbx 
    mov al, byte [rsi+rcx]; Put a byte from the input buffer into al 
    mov rbx , rax ; Duplicate byte in bl for second nibble 
    ; Look up low nybble character and insert it into the string 
    and al, 0x0F ; Mask out all low nymble 
    mov al, byte [Digits + rax ];Look up the charcter equivilant of the line string 
    mov byte[HexStr+rdx+2], al ; Write the char equivalent to the line string 

    ; Look up high nymbble charcater and insert it into tyhe string 
    shr bl, 4 ; shift 4 bits of char into low 4 bits 
    mov bl, byte[Digits+rbx] ; Look up equvalent charcter of the bymbble 
    mov byte[HexStr+ rdx+ 1], bl ; Write the char equvalent to the line string 

    ; Bumnp the buffer pointer to the next charcter and see if we are done 
    inc rcx ; Incrent line string pointer 
    cmp rcx , r15 ; compare number of characters in the buffer 
    jna Scan ; look back if rcs is <= number of chars d in buffer 

    ; Write the lines of hexadecimal values to stdout : 
    mov rax , 1 ; syscall ! i.e sys_write 
    mov rdi,1 ; sosecify the file descriptor 1: standard output 
    mov rsi , HexStr ; Pass the address of the line string in rsi 
    mov rdx ,HEXLEN ; pass the size of the len string in rdx 
    syscall ; Make kernel call to display line to string 
    jmp Read ; LLoop back and load file buffer again 

Done: 
    ret ; return to the gblic shutdown code 