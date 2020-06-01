.586
.model flat, stdcall

option casemap :none
include F:\masm32\include\kernel32.inc
include F:\masm32\include\user32.inc
include F:\masm32\include\windows.inc
includelib F:\masm32\lib\kernel32.lib
includelib F:\masm32\lib\user32.lib
include module.inc
include longop.inc

.data
	N0 db 104 dup(170)
	n dd 64
	m0 db 22 dup(85)
	m dd 128
	TextBuf0 db 256 dup(?)
	TextBuf1 db 256 dup(?)
	Caption0 db "¬х≥дн≥ дан≥",0
	Caption1 db "ќтриманий результат",0

.code

start:
	push offset TextBuf0
	push offset N0
	push 480
	call StrHex_MY
	invoke MessageBox, 0, ADDR TextBuf0, ADDR Caption0, MB_ICONINFORMATION

	push offset N0
	push offset m0
	push n
	push m
	call AND_Longop
	push offset TextBuf1
	push offset N0
	push 480
	call StrHex_MY
	invoke MessageBox, 0, ADDR TextBuf1, ADDR Caption1, MB_ICONINFORMATION
	invoke ExitProcess, 0

end start