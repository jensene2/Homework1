%include "asm_io.inc"
segment .data 
PromptFileUnit		db	"Enter the unit for file size:", 0
PromptThroughUnit	db	"Enter the unit for throughput:", 0
PromptFileSize		db	"Enter the file size:", 0
PromptThroughSize	db	"Enter the throughput:", 0
Output			db	"The time would be ", 0
Seconds			db	" seconds.", 0

InvalidInput		db	"Invalid input.", 0

segment .bss 
fileMultiplier		resd 1
throughMultiplier	resd 1


segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
	;***************CODE STARTS HERE***************************

	mov	dword [fileMultiplier], 8
	mov	dword [throughMultiplier], 1

	mov	eax, PromptFileUnit
	call	print_string
	call	read_char

	;call	LoadBKMValues
	mov	ebx, 0x00000042
	mov	ecx, 0x0000004B
	mov	edx, 0x0000004D

	dump_regs 3

	cmp	eax, ebx
	jz	throughput

	cmp	eax, ecx
	jz	kiloFile

	cmp	eax, edx
	jz	megaFile

	jmp	invalid
kiloFile:
	shl	dword [fileMultiplier], 10

	;mov	eax, [fileMultiplier]
	;mul	0x00000400 ; 1024
	;mov	[fileMultiplier], eax

	jmp	throughput
megaFile:
	shl	dword [fileMultiplier], 20

	;mov	eax, [fileMultiplier]
	;mul	0x00100000 ; 1024 * 1024
	;mov	[fileMultiplier], eax
throughput:
	dump_regs 0

	mov	eax, PromptThroughUnit
	call	print_string

	dump_regs 2
	call	read_int

	dump_regs 1

	cmp	eax, ebx
	jz	calculate

	cmp	eax, ecx
	jz	kiloThrough

	cmp	eax, edx
	jz	megaThrough

	jmp	invalid
kiloThrough:
	shl	dword [throughMultiplier], 10

	jmp calculate
megaThrough:
	shl	dword [throughMultiplier], 20
calculate:
	mov	eax, PromptFileSize
	call	print_string

	mov	eax, 0
	mov	edx, 0

	call	read_int
	mul	dword [fileMultiplier]
	push	eax
	push	edx

	mov	eax, PromptThroughSize
	call	print_string

	mov	eax, Output
	call	print_string

	mov	edx, 0
	call	read_int
	mul	dword [throughMultiplier]

	mov	ecx, eax
	mov	ebx, edx

	pop	eax
	pop	edx

	div	ecx
	call	print_int

	mov	eax, Seconds
	call	print_string
	jmp	exit
invalid:
	mov	eax, InvalidInput
	call	print_string

exit:	
	call	print_nl
		
	;***************CODE ENDS HERE*****************************
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


; subprogram LoadBKMValues
; Parameters:
;	None
; Notes:
;	Overwrites ebx, ecx, and edx
LoadBKMValues:
	enter 0, 0

	mov	ebx, 0x00000042 ; B
	mov	ecx, 0x0000004B ; K
	mov	edx, 0x0000004D ; M

	leave
	ret
