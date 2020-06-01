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
    Value dd -12.3224
    Caption db "LAB8", 0
	TextBuf dd 10 dup(?)
	valA dd 5.6, 4.1, 2.7, 3.5
	valB dd 2.4, 3.2, 1.1, 0.3
	valX dd 3.8
	valN dd 1
	Res dd 0.0

.code
main:
    push offset TextBuf
	push Value
	call FloatToDec32
	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

	xor ecx, ecx
	fld Res
@formula:
	fild valN
	fld valX
	fsub dword ptr [valB+4*ecx]
	fyl2x
	fld st(0)
	frndint
	fxch st(1)
	fsub st(0), st(1)
	f2xm1
	fld1
	faddp st(1), st(0)
	fscale
	fstp st(1)
	fmul dword ptr [valA+4*ecx]
	faddp st(1), st(0)
	inc ecx
	inc valN
	cmp ecx, 4
	jne @formula

	fstp Res

	push offset TextBuf
	push Res
	call FloatToDec32
	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

    invoke ExitProcess, 0
end main