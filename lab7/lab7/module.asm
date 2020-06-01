.586
.model flat, c

include longop.inc

.data
    remainder db 0
	n dd 0

.code

;��������� StrHex_MY ������ ����� ����������������� ����
;������ �������� - ������ ������ ���������� (����� �������)
;������ �������� - ������ �����
;����� �������� - ���������� ����� � ���� (�� ���� ������ 8)
StrHex_MY proc
    push ebp
	mov ebp, esp
	mov ecx, [ebp+8]    ;������� ��� �����
	cmp ecx, 0
	jle @exitp
	shr ecx, 3          ;������� ����� �����
	mov esi, [ebp+12]   ;������ �����
	mov ebx, [ebp+16]   ;������ ������ ����������
@cycle:
    mov dl, byte ptr[esi+ecx-1] ;���� ����� - �� �� hex-�����

	mov al, dl
	shr al, 4                   ;������ �����
	call HexSymbol_MY
	mov byte ptr[ebx], al

	mov al, dl                  ;������� �����
	call HexSymbol_MY
	mov byte ptr[ebx+1], al

	mov eax, ecx
	cmp eax, 4
	jle @next
	dec eax
	and eax, 3                 ;������� ������� ����� �� ��� ����
	cmp al, 0
	jne @next
	mov byte ptr[ebx+2], 32    ;��� ������� �������
	inc ebx

@next:
    add ebx, 2
	dec ecx
	jnz @cycle
	mov byte ptr[ebx], 0      ;����� ���������� �����
@exitp:
    pop ebp
	ret 12
StrHex_MY endp

;�� ��������� �������� ��� hex-�����
;�������� - �������� AL
;��������� -> AL
HexSymbol_MY proc
    and al, 0Fh
	add al, 48      ;��� ����� ����� ��� ���� 0-9
	cmp al, 58
	jl @exitp
	add al, 7       ;��� ���� A,B,C,D,E,F
@exitp:
    ret
HexSymbol_MY endp

StrDec proc
    push ebp
	mov ebp, esp
    mov ecx, [ebp+8]    ;������� ��� �����
	mov esi, [ebp+12]   ;������ �����
	mov ebx, [ebp+16]   ;������ ������ ����������

	mov n, 0
@start:
    push ecx
	push ebx

	push esi
	push ecx
	push esi
	push offset remainder
	call Div10var2_LONGOP

	add remainder, 48
	mov al, remainder
	pop ebx

	mov edi, n
@shift:
    cmp edi, 0
	je @go
	dec edi
	mov ah, byte ptr [ebx+edi]
	mov byte ptr [ebx+edi+1], ah
	jmp @shift

@go:
	mov byte ptr [ebx], al
	inc n

	pop ecx
	mov edi, ecx
	shr edi, 5
	dec edi

@checkforzero:
	test dword ptr [esi+4*edi], 0FFFFFFFFh
	jnz @start
	dec edi
	cmp edi, -1
	jnz @checkforzero

	add ebx, n
	mov byte ptr [ebx], 0
	sub ebx, n
	pop ebp
	ret 12
StrDec endp

end