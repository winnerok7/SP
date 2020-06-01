.586
.model flat, stdcall

option casemap :none
include F:\masm32\include\kernel32.inc
include F:\masm32\include\user32.inc
include F:\masm32\include\windows.inc
include module.inc
include longop.inc

includelib F:\masm32\lib\kernel32.lib
includelib F:\masm32\lib\user32.lib

.data
    Caption1 db "Частка", 0
	Caption2 db "Залишок", 0
	Caption3 db "У десятковій системі", 0
	Caption4 db "Func", 0

	Result dd 2 dup(0)
	Remainder db 0
	Value dd 0FFFFFFFFh, 0FFFFFFFFh
	TextBuf dd 10 dup(?)

	x dd 10
	m dd 3
	y dd 0

	ValueA dd 00000001h,  00000000h, 00000000h, 00000000h, 00000000h, 00000000h
	ValueB dd 00000002h
	ResultFact dd 7 dup(0)

	Caption5 db "46!", 0

.code
main:
    push offset Value
	push offset 64
	push offset Result
	push offset Remainder
	call Div10_LONGOP
	push offset TextBuf
	push offset Result
	push 64
	call StrHex_MY
	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption1, 0
	push offset TextBuf
	push offset Remainder
	push 8
	call StrHex_MY
	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption2, 0

	push offset Value
	push offset 64
	push offset Result
	push offset Remainder
	call Div10var2_LONGOP
	push offset TextBuf
	push offset Result
	push 64
	call StrHex_MY
	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption1, 0
	push offset TextBuf
	push offset Remainder
	push 8
	call StrHex_MY
	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption2, 0

	push offset TextBuf
	push offset Value
	push 64
	call StrDec
	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption3, 0

	mov eax, x
	cdq
	mov ecx, 5
	idiv ecx
	mov ecx, m
	inc ecx
	shl eax, cl
	mov y, eax
	push offset TextBuf
	push offset y
	push 32
	call StrHex_MY
	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption4, 0

@factorial:
	push offset ValueA
	push offset ValueB
	push offset ResultFact
	call Mult_192x32_LONGOP
	
	inc ValueB
	cmp ValueB, 47
	je @endoffact
	xor ebx, ebx
@copy:
	mov eax, dword ptr [ResultFact+4*ebx]
	mov dword ptr [ResultFact+4*ebx], 0
	mov dword ptr [ValueA+4*ebx], eax
	inc ebx
	cmp ebx, 6
	jne @copy
	jmp @factorial

@endoffact:
	push offset TextBuf
    push offset ResultFact
    push 224
    call StrDec
    invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption5, 0

    invoke ExitProcess, 0
end main