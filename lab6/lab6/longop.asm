.586
.model flat, c

.code
AND_Longop proc

	push ebp
	mov ebp, esp
	mov ecx, [ebp + 8] ;���������� �����
	mov edx, [ebp + 12] ;����� ���
	mov esi, [ebp + 16] ;������ �����
	mov edi, [ebp + 20] ;������ ��������� �����
	shr ecx, 3
	shr edx, 3

cycleAND:
	add edx, ecx
	mov al, byte ptr [edi + edx - 1]
	and al, byte ptr [esi + ecx - 1]
	mov byte ptr [edi + edx - 1], al

	sub edx, ecx
	dec ecx
	jnz cycleAND

	pop ebp
	ret 16
AND_Longop endp

End