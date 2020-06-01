.586
.model flat, c

include longop.inc

.data
    remainder db 0
	n dd 0

.code

;процедура StrHex_MY записує текст шістнадцятькового коду
;перший параметр - адреса буфера результату (рядка символів)
;другий параметр - адреса числа
;третій параметр - розрядність числа у бітах (має бути кратна 8)
StrHex_MY proc bits:DWORD, src:DWORD, dest:DWORD
	mov ecx, bits    ;кількість бітів числа
	cmp ecx, 0
	jle @exitp
	shr ecx, 3          ;кількість байтів числа
	mov esi, src    ;адреса числа
	mov ebx, dest   ;адреса буфера результату
@cycle:
    mov dl, byte ptr[esi+ecx-1] ;байт числа - це дві hex-цифри

	mov al, dl
	shr al, 4                   ;старша цифра
	call HexSymbol_MY
	mov byte ptr[ebx], al

	mov al, dl                  ;молодша цифра
	call HexSymbol_MY
	mov byte ptr[ebx+1], al

	mov eax, ecx
	cmp eax, 4
	jle @next
	dec eax
	and eax, 3                 ;проміжок розділює групи по вісім цифр
	cmp al, 0
	jne @next
	mov byte ptr[ebx+2], 32    ;код символа проміжку
	inc ebx

@next:
    add ebx, 2
	dec ecx
	jnz @cycle
	mov byte ptr[ebx], 0      ;рядок закінчується нулем
@exitp:
	ret
StrHex_MY endp

;ця процедура обчислює код hex-цифри
;параметр - значення AL
;результат -> AL
HexSymbol_MY proc
    and al, 0Fh
	add al, 48      ;так можна тільки для цифр 0-9
	cmp al, 58
	jl @exitp
	add al, 7       ;для цифр A,B,C,D,E,F
@exitp:
    ret
HexSymbol_MY endp

StrDec proc bits:DWORD, src:DWORD, dest:DWORD
    mov ecx, bits    ;кількість бітів числа
	mov esi, src     ;адреса числа
	mov ebx, dest    ;адреса буфера результату

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
    mov edi, [ebp+8]    ;число
	mov esi, [ebp+12]   ;адреса буфера результату

	mov eax, edi
	and eax, 7F800000h   ;експонента
	jz @end0

	shr eax, 23
	
	mov ebx, eax
	xor ebx, 000000FFh  ;перевірка експоненти на одиниці
	jz @end1

	test edi, 80000000h  ;перевірити біт знаку
	jz @go
	mov byte ptr [esi], 45  ;записати мінус
	jmp @next

@go:
    mov byte ptr [esi], 43  ;записати плюс

@next:
    inc esi

	sub eax, 127 ;порівнюємо експоненту
	jz @zero
	js @minus

	and edi, 007FFFFFh  ;виділяємо мантису
	add edi, 0800000h
	mov ecx, 23
	sub ecx, eax   ;23-E
	mov ebx, edi
	shr ebx, cl   ;ціла частина
	mov ecx, eax
	shl edi, cl
	and edi, 007FFFFFh   ;дробова частина
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
	mov byte ptr [esi], 46 ;записати крапку
	inc esi

	pop edi
    call FindDrob
	jmp @end

@zero:         ;експонента дорівнює нулю
    mov byte ptr [esi], 49 ;записати 1
	inc esi
	mov byte ptr [esi], 46 ;записати крапку
	inc esi
	and edi, 007FFFFFh ;виділяємо мантису
    call FindDrob
	jmp @end

@minus:        ;експонента менше нуля
    mov byte ptr [esi], 48 ;записати 0
	inc esi
	mov byte ptr [esi], 46 ;записати крапку
	inc esi
    and edi, 007FFFFFh ;виділяємо мантису
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
    mov byte ptr [esi], 0 ;закінчуємо рядок нулем
	jmp @end

@end1:
	mov byte ptr [esi], 78 ;N
	inc esi
	mov byte ptr [esi], 97 ;a
	inc esi
	mov byte ptr [esi], 78 ;N
	inc esi
    mov byte ptr [esi], 0 ;закінчуємо рядок нулем

@end:
	pop ebp
	ret 8
FloatToDec32 endp

FindDrob proc
    mov ecx, 6
@start:
    mov eax, edi
    shl edi, 1    ;зсуваємо на 1 біт вліво
	shl eax, 3    ;зсуваємо на 3 біти вліво
	add edi, eax  ;отримуємо множення на 10
	mov eax, edi
	and edi, 007FFFFFh
	and eax, 0FF800000h
	shr eax, 23
	add eax, 48  ;додаємо 48 для отримання ASCII
	mov byte ptr [esi], al
	inc esi
	dec ecx
	jnz @start

	mov byte ptr [esi], 0 ;закінчуємо рядок нулем
	ret
FindDrob endp

end