.586
.model flat, c

.data
k dd ?

.code
Add_320_LONGOP proc
    push ebp
    mov ebp, esp
    mov esi, [ebp+16]
    mov ebx, [ebp+12]
    mov edi, [ebp+8]
    mov ecx, 10
    mov edx, 0
    clc
@cycle:
    mov eax, dword ptr[esi+4*edx]
    adc eax, dword ptr[ebx+4*edx]
    mov dword ptr[edi+4*edx], eax
    inc edx
    dec ecx
    jnz @cycle
    pop ebp
    ret 12
Add_320_LONGOP endp

Sub_800_LONGOP proc
    push ebp
    mov ebp, esp
    mov esi, [ebp+16]
    mov ebx, [ebp+12]
    mov edi, [ebp+8]

    mov ecx, 25
    mov edx, 0
    clc
@cycle:
    mov eax, dword ptr[esi+4*edx]
    sbb eax, dword ptr[ebx+4*edx]
    mov dword ptr[edi+4*edx], eax
    inc edx
    dec ecx
    jnz @cycle
    pop ebp
    ret 12
Sub_800_LONGOP endp

Mult_192x32_LONGOP proc
    push ebp
    mov ebp, esp
    mov esi, [ebp+16] ;число1
    mov ebx, [ebp+12] ;число2
    mov edi, [ebp+8]  ;результат

    xor ecx, ecx
@cycle:
    mov eax, dword ptr [esi+4*ecx]
    mul dword ptr [ebx]
    add dword ptr [edi+4*ecx], eax
    adc dword ptr [edi+4*ecx+4], edx
	inc ecx
    cmp ecx, 6
    jne @cycle

    pop ebp
    ret 12
Mult_192x32_LONGOP endp

Mult_192x192_LONGOP proc
    push ebp
    mov ebp, esp
    mov esi, [ebp+16] ;число1
    mov ebx, [ebp+12] ;число2
    mov edi, [ebp+8]  ;результат

	mov k, 0 
@start:
	xor ecx, ecx
@startmul32:
	cmp ecx, 6
	je @next
	mov eax, dword ptr [esi+4*ecx]
	push ecx
	mov ecx, k
	mul dword ptr [ebx+4*ecx]
	pop ecx
	add ecx, k
	add dword ptr [edi+4*ecx], eax
	adc dword ptr [edi+4*ecx+4], edx
	jnc @go
	push ecx
	dec ecx
@carry:
    inc ecx
	add dword ptr [edi+4*ecx+8], 00000001h
	jc @carry
	pop ecx

@go:
	sub ecx, k
	inc ecx
	jmp @startmul32

@next:
    cmp k, 5
	je @end
	inc k
	jmp @start

@end:
	pop ebp
    ret 12
Mult_192x192_LONGOP endp

Shr_LONGOP proc
    push ebp
    mov ebp, esp
    mov esi, [ebp+16] ;адреса джерела
    mov edx, [ebp+12] ;адреса результату
    mov edi, [ebp+8]  ;розрядність

	mov dword ptr [edx], 0
	dec edi

@start:
	mov ebx, edi      ;номер біту
	mov ecx, ebx
	shr ebx, 3        ;номер байту
	
	and ecx, 07h      ;бітова позиція
	mov al, 1
	shl al, cl

	mov ah, byte ptr [esi+ebx]
	and ah, al

	cmp ah, 0
	jnz @end
	inc dword ptr [edx]

	dec edi
	cmp edi, 0
	jnz @start

@end:
	pop ebp
	ret 12
Shr_LONGOP endp

Shr2_LONGOP proc
    push ebp
    mov ebp, esp
    mov esi, [ebp+16] ;адреса джерела
    mov edi, [ebp+12] ;розрядність
	mov eax, [ebp+8]  ;зсув

	shr edi, 5
	dec edi
	xor edx, edx

@startsar:
	xor ecx, ecx

@sarlong:
	cmp ecx, edi
	je @last
	mov ebx, dword ptr [esi+4*ecx]
	shr ebx, 1
	mov dword ptr [esi+4*ecx], ebx

	test dword ptr [esi+4*ecx+4], 00000001h
	jz @nextdword
	add dword ptr [esi+4*ecx], 80000000h

@nextdword:
    inc ecx
	jmp @sarlong

@last:
    mov ebx, dword ptr [esi+4*ecx]
	sar ebx, 1
	mov dword ptr [esi+4*ecx], ebx
	inc edx
	cmp edx, eax
	je @exit
	jmp @startsar

@exit:
	pop ebp
	ret 12
Shr2_LONGOP endp

Div10_LONGOP proc
    push ebp
	mov ebp, esp
	mov eax, [ebp+20] ;адреса числа
    mov ebx, [ebp+16] ;розрядність
	mov esi, [ebp+12] ;адреса результату
	mov edi, [ebp+8]  ;адреса залишку

	push ebx
	mov ecx, ebx
	shr ecx, 3  ;кількість байтів
	dec ecx

	sub ebx, 4   ;i=n-4

	mov dl, byte ptr [eax+ecx]  ;останній байт
	shr dl, 4                   ;4 старші біти

	pop ecx
	shr ecx, 5   ;кількість подвійних слів
	dec ecx

@startdiv:
	cmp dl, 10
	jb @below
	sub dl, 10
	push ecx
	call ShiftLeft            ;записати 1 у результат
	pop ecx
	add dword ptr [esi], 1
	jmp @check
@below:
    push ecx
    call ShiftLeft            ;записати 0 у результат
	pop ecx
@check:
    cmp ebx, 0
	je @enddiv
	dec ebx
	shl dl, 1

	push ebx
	push ecx

	mov ecx, ebx
	shr ebx, 3    ;номер байту
	and ecx, 07h  ;вирізаємо 3 молодші біти
	mov dh, 1
	shl dh, cl    ;маска для вирізання
	mov cl, byte ptr [eax+ebx]
	and cl, dh
	jz @go
	add dl, 1

@go:
	pop ecx
	pop ebx
	jmp @startdiv

@enddiv:
    mov [edi], dl
	pop ebp
	ret 16
Div10_LONGOP endp

ShiftLeft proc
@start:
	shl dword ptr [esi+4*ecx], 1
	jnc @next
	add dword ptr [esi+4*ecx+4], 1
@next:
    dec ecx
	cmp ecx, -1
	jne @start
	ret
ShiftLeft endp

Div10var2_LONGOP proc
    push ebp
	mov ebp, esp
	mov ecx, [ebp+20] ;адреса числа
    mov ebx, [ebp+16] ;розрядність
	mov esi, [ebp+12] ;адреса результату
	mov edi, [ebp+8]  ;адреса залишку

	push edi
	shr ebx, 5 ;кількість подвійних слів
	dec ebx

	xor edx, edx
@start:
	mov eax, dword ptr [ecx+4*ebx]
    mov edi, 10
	div edi
	mov dword ptr [esi+4*ebx], eax
	dec ebx
	cmp ebx, -1
	jne @start

	pop edi
	mov byte ptr [edi], dl
	pop ebp
	ret 16
Div10var2_LONGOP endp

end