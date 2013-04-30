;**************************************************************
; Author  : TheROPFather                                      *
; Date    : 02/04/2013                                        *
; Contact : theropfather@gmail.com | twitter.com/theropfather *
; Compile : nasm -f macho -o pid.o space.asm                  *
; Link    : ld -macosx_version_min 10.7 -o pid pid.o          *          
; Descr.  : Prints the process PID, could be used in a        *
;           larger program.                                   *
; Nasm v. : NASM version 0.98.40                              * 
;**************************************************************

SECTION .data

LookUpDig db "0123456789"                 ; Lookup for ASCII

PIDString db "PID: "
PIDLength equ $-PIDString

SECTION .bss

PID: resb 8                               ; Reserver space for result

SECTION .text

global start

start:
	mov eax, 0x14                     ; GET_PID call
	int 0x80                          ; Call  
	mov ebx, 0xA                      ; Set divider to 10
	lea ebp, [PID+6]                  ; LEA PID Buffer 6byte in
	jmp ASCIIConv                     ; Run the loop to convert int to string
ASCIIConv: 
	div ebx                           ; Divide the PID
	mov byte cl, [LookUpDig+edx]	  ; Copy ASCII value to CL
	mov [ebp], cl                     ; Copy ASCII value to buffer
	dec ebp                           ; Next byte into buffer
	xor edx, edx                      ; Clear the remainder
	inc eax                           ; Dec eax tricking jnz
	dec eax                           ; Push back to original value
	jnz ASCIIConv                     ; Keep looping until eax is zero
	jz .printOut                       ; Print out the buffer
.printOut:
	push PIDLength                    ; Push PIDString Length
	push PIDString                    ; Push PIDString
	push 0x1                          ; FD stdout
	mov eax, 0x4                      ; sys_write call
	push eax                          ; Push call (BSD)
	int 0x80                          ; Call
	add esp, 0x10                     ; Clear up the stack
	
	mov [PID+7], byte 0xA             ; Push a newline to PID string
	
	push 0x8                          ; Max length of 8 bytes
	push PID                          ; Push PID value
	push 0x1                          ; FD stdout
	mov eax, 0x4                      ; sys_write call
	push eax                          ; Push call (BSD)
	int 0x80                          ; Call
	add esp, 0x10                     ; Clean up stack

	mov eax, 0x1                      ; Set system_call
	push 0x0                          ; Exit_code 0
	int 0x80                          ; Call
