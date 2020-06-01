.586
.model flat, stdcall

option casemap :none
include F:\masm32\include\kernel32.inc
include F:\masm32\include\user32.inc
include F:\masm32\include\windows.inc
include F:\masm32\include\comdlg32.inc
include module.inc
include longop.inc

includelib F:\masm32\lib\kernel32.lib
includelib F:\masm32\lib\user32.lib
includelib F:\masm32\lib\comdlg32.lib

.data
    hFile dd 0
	pRes dd 0
	FileName dd ?
    ;szFileName db 256 dup(0)
	szTextBuf dd 16 dup(?)

	ValueA dd 00000001h, 00000000h, 00000000h, 00000000h, 00000000h, 00000000h
	ValueB dd 00000001h
	ResultFact dd 7 dup(0)
	newline db 10

.code

MySaveFileName proc
    LOCAL ofn : OPENFILENAME

	invoke RtlZeroMemory, ADDR ofn, SIZEOF ofn
	mov ofn.lStructSize, SIZEOF ofn
	mov eax, FileName
	mov ofn.lpstrFile, eax
	mov ofn.nMaxFile, 256

	invoke GetSaveFileName, ADDR ofn
	ret
MySaveFileName endp

main:
    invoke GlobalAlloc, GPTR, 256
	mov FileName, eax

    call MySaveFileName
	cmp eax, 0 ;перевірка: якщо у вікні було натиснуто кнопку Cancel, то EAX=0
	je @exit

	invoke CreateFile, FileName,
	                   GENERIC_WRITE,
					   FILE_SHARE_WRITE,
					   0, CREATE_ALWAYS,
					   FILE_ATTRIBUTE_NORMAL,
					   0

	cmp eax, INVALID_HANDLE_VALUE
	je @exit
	mov hFile, eax

@factorial:
    cmp ValueB, 47
	je @endoffact

	push offset ValueA
	push offset ValueB
	push offset ResultFact
	call Mult_192x32_LONGOP
	
	push offset szTextBuf
    push offset ResultFact
    push 224
    call StrHex_MY
	
	invoke lstrlen, ADDR szTextBuf
	invoke WriteFile, hFile, ADDR szTextBuf, eax, ADDR pRes, 0
	invoke WriteFile, hFile, ADDR newline, 1, ADDR pRes, 0


	xor ebx, ebx
@copy:
	mov eax, dword ptr [ResultFact+4*ebx]
	mov dword ptr [ResultFact+4*ebx], 0
	mov dword ptr [ValueA+4*ebx], eax
	inc ebx
	cmp ebx, 6
	jne @copy

	inc ValueB
	jmp @factorial

@endoffact:
	invoke CloseHandle, hFile

@exit:
    invoke GlobalFree, FileName

    invoke ExitProcess, 0
end main