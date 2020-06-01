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
StrHex_MY proc bits:DWORD, src:DWORD, dest:DWORD
	mov ecx, bits    ;������� ��� �����
	cmp ecx, 0
	jle @exitp
	shr ecx, 3          ;������� ����� �����
	mov esi, src    ;������ �����
	mov ebx, dest   ;������ ������ ����������
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
	ret
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

StrDec proc bits:DWORD, src:DWORD, dest:DWORD
    mov ecx, bits    ;������� ��� �����
	mov esi, src     ;������ �����
	mov ebx, dest    ;������ ������ ����������

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
	ret
StrDec endp

FloatToDec32 proc
    push ebp
	mov ebp, esp
    mov edi, [ebp+8]    ;�����
	mov esi, [ebp+12]   ;������ ������ ����������

	mov eax, edi
	and eax, 7F800000h   ;����������
	jz @end0

	shr eax, 23
	
	mov ebx, eax
	xor ebx, 000000FFh  ;�������� ���������� �� �������
	jz @end1

	test edi, 80000000h  ;��������� �� �����
	jz @go
	mov byte ptr [esi], 45  ;�������� ����
	jmp @next

@go:
    mov byte ptr [esi], 43  ;�������� ����

@next:
    inc esi

	sub eax, 127 ;��������� ����������
	jz @zero
	js @minus

	and edi, 007FFFFFh  ;�������� �������
	add edi, 0800000h
	mov ecx, 23
	sub ecx, eax   ;23-E
	mov ebx, edi
	shr ebx, cl   ;���� �������
	mov ecx, eax
	shl edi, cl
	and edi, 007FFFFFh   ;������� �������
	push edi

	mov eax, ebx
	xor edi, edi
@div:
    xor ecx, ecx
	xor edx, edx
	mov ebx, 10
	div ebx
	add edx, 48
	
	mov ecx, edi
@shift:
	cmp ecx, 0
	je @write
	dec ecx
	mov bl, byte ptr [esi+ecx]
	mov byte ptr [esi+ecx+1], bl
	jmp @shift

@write:
	mov byte ptr [esi], dl
	inc edi
	;inc esi
	cmp eax, 0
	jne @div

	add esi, edi
	mov byte ptr [esi], 46 ;�������� ������
	inc esi

	pop edi
    call FindDrob
	jmp @end

@zero:         ;���������� ������� ����
    mov byte ptr [esi], 49 ;�������� 1
	inc esi
	mov byte ptr [esi], 46 ;�������� ������
	inc esi
	and edi, 007FFFFFh ;�������� �������
    call FindDrob
	jmp @end

@minus:        ;���������� ����� ����
    mov byte ptr [esi], 48 ;�������� 0
	inc esi
	mov byte ptr [esi], 46 ;�������� ������
	inc esi
    and edi, 007FFFFFh ;�������� �������
    call FindDrob
	jmp @end

@end0:
    mov byte ptr [esi], 122 ;z
	inc esi
	mov byte ptr [esi], 101 ;e
	inc esi
	mov byte ptr [esi], 114 ;r
	inc esi
	mov byte ptr [esi], 111 ;o
	inc esi
    mov byte ptr [esi], 0 ;�������� ����� �����
	jmp @end

@end1:
	mov byte ptr [esi], 78 ;N
	inc esi
	mov byte ptr [esi], 97 ;a
	inc esi
	mov byte ptr [esi], 78 ;N
	inc esi
    mov byte ptr [esi], 0 ;�������� ����� �����

@end:
	pop ebp
	ret 8
FloatToDec32 endp

FindDrob proc
    mov ecx, 6
@start:
    mov eax, edi
    shl edi, 1    ;������� �� 1 �� ����
	shl eax, 3    ;������� �� 3 ��� ����
	add edi, eax  ;�������� �������� �� 10
	mov eax, edi
	and edi, 007FFFFFh
	and eax, 0FF800000h
	shr eax, 23
	add eax, 48  ;������ 48 ��� ��������� ASCII
	mov byte ptr [esi], al
	inc esi
	dec ecx
	jnz @start

	mov byte ptr [esi], 0 ;�������� ����� �����
	ret
FindDrob endp

end