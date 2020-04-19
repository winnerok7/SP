.586
.model flat, stdcall

option casemap : none
include F:\masm32\include\windows.inc
include F:\masm32\include\kernel32.inc
include F:\masm32\include\user32.inc

include longop.inc
include module.inc

includelib F:\masm32\lib\kernel32.lib
includelib F:\masm32\lib\user32.lib


.data
Caption0 db "Лабораторна №4", 0
Text db "Виконав Буцев Богдан", 0
Caption1 db "A + B", 0
Caption12 db "A + B", 0
Caption2 db "A - B", 0
 
Arr1 db 10 dup(?)
Arr12 db 10 dup(?)
Arr2 db 25 dup(?)

A1 dd 10 dup(?)
B1 dd 10 dup(?)
A12 dd 10 dup(?)
B12 dd 10 dup(?)
A2 dd 25 dup(?)
B2 dd 25 dup(?)

Res1 dd 10 dup(?)
Res12 dd 10 dup(?)
Res2 dd 25 dup(?)


.code

main:
invoke MessageBoxA, 0, ADDR Text, ADDR Caption0, 0

mov eax, 80010001h

mov dword ptr[A1], eax
add eax, 10000h
mov dword ptr[B1], 80000001h

mov dword ptr[A1 + 4], eax
add eax, 10000h
mov dword ptr[B1 + 4], 80000001h

mov dword ptr[A1 + 8], eax
add eax, 10000h
mov dword ptr[B1 + 8], 80000001h

mov dword ptr[A1 + 12], eax
add eax, 10000h
mov dword ptr[B1 + 12], 80000001h

mov dword ptr[A1 + 16], eax
add eax, 10000h
mov dword ptr[B1 + 16], 80000001h

mov dword ptr[A1 + 20], eax
add eax, 10000h
mov dword ptr[B1 + 20], 80000001h

mov dword ptr[A1 + 24], eax
add eax, 10000h
mov dword ptr[B1 + 24], 80000001h

mov dword ptr[A1 + 28], eax
add eax, 10000h
mov dword ptr[B1 + 28], 80000001h

mov dword ptr[A1 + 32], eax
add eax, 10000h
mov dword ptr[B1 + 32], 80000001h

mov dword ptr[A1 + 36], eax
add eax, 10000h
mov dword ptr[B1 + 36], 80000001h

mov dword ptr[A1 + 40], eax
add eax, 10000h
mov dword ptr[B1 + 40], 80000001h

mov dword ptr[A1 + 44], eax
add eax, 10000h
mov dword ptr[B1 + 44], 80000001h

mov dword ptr[A1 + 48], eax
add eax, 10000h
mov dword ptr[B1 + 48], 80000001h

mov dword ptr[A1 + 52], eax
add eax, 10000h
mov dword ptr[B1 + 52], 80000001h

mov dword ptr[A1 + 56], eax
add eax, 10000h
mov dword ptr[B1 + 56], 80000001h

mov dword ptr[A1 + 60], eax
add eax, 10000h
mov dword ptr[B1 + 60], 80000001h

mov dword ptr[A1 + 64], eax
add eax, 10000h
mov dword ptr[B1 + 64], 80000001h

mov dword ptr[A1 + 68], eax
add eax, 10000h
mov dword ptr[B1 + 68], 80000001h

mov dword ptr[A1 + 72], eax
add eax, 10000h
mov dword ptr[B1 + 72], 80000001h

mov dword ptr[A1 + 76], eax
add eax, 10000h
mov dword ptr[B1 + 76], 80000001h

push offset A1
push offset B1
push offset Res1
call Add_320_LONGOP
push offset Arr1
push offset Res1
push 320
call StrHex_MY
invoke MessageBoxA, 0, ADDR Arr1, ADDR Caption1, 0

mov eax, 8h
mov ecx, 10
mov edx, 0
cycle:
mov dword ptr[A12 + 4 * edx], eax
add eax, 1h
mov dword ptr[B12 + 4 * edx], 00000001h
inc edx
dec ecx
jnz cycle

push offset A12
push offset B12
push offset Res12
call Add_320_LONGOP
push offset Arr12
push offset Res12
push 320
call StrHex_MY
invoke MessageBoxA, 0, ADDR Arr12, ADDR Caption12, 0

mov eax, 8h						; вар

mov eax, 18h; вар

mov dword ptr[A2], eax
add eax, 1h
mov dword ptr[B2], 00000001h

mov dword ptr[A2 + 4], eax
add eax, 1h
mov dword ptr[B2 + 4], 00000001h

mov dword ptr[A2 + 8], eax
add eax, 1h
mov dword ptr[B2 + 8], 00000001h

mov dword ptr[A2 + 12], eax
add eax, 1h
mov dword ptr[B2 + 12], 00000001h

mov dword ptr[A2 + 16], eax
add eax, 1h
mov dword ptr[B2 + 16], 00000001h

mov dword ptr[A2 + 20], eax
add eax, 1h
mov dword ptr[B2 + 20], 00000001h

mov dword ptr[A2 + 24], eax
add eax, 1h
mov dword ptr[B2 + 24], 00000001h

mov dword ptr[A2 + 28], eax
add eax, 1h
mov dword ptr[B2 + 28], 00000001h

mov dword ptr[A2 + 32], eax
add eax, 1h
mov dword ptr[B2 + 32], 00000001h

mov dword ptr[A2 + 36], eax
add eax, 1h
mov dword ptr[B2 + 36], 00000001h

mov dword ptr[A2 + 40], eax
add eax, 1h
mov dword ptr[B2 + 40], 00000001h

mov dword ptr[A2 + 44], eax
add eax, 1h
mov dword ptr[B2 + 44], 00000001h

mov dword ptr[A2 + 48], eax
add eax, 1h
mov dword ptr[B2 + 48], 00000001h

mov dword ptr[A2 + 52], eax
add eax, 1h
mov dword ptr[B2 + 52], 00000001h

mov dword ptr[A2 + 56], eax
add eax, 1h
mov dword ptr[B2 + 56], 00000001h

mov dword ptr[A2 + 60], eax
add eax, 1h
mov dword ptr[B2 + 60], 00000001h

mov dword ptr[A2 + 64], eax
add eax, 1h
mov dword ptr[B2 + 64], 00000001h

mov dword ptr[A2 + 68], eax
add eax, 1h
mov dword ptr[B2 + 68], 00000001h

mov dword ptr[A2 + 72], eax
add eax, 1h
mov dword ptr[B2 + 72], 00000001h

mov dword ptr[A2 + 76], eax
add eax, 1h
mov dword ptr[B2 + 76], 00000001h

push offset A2
push offset B2
push offset Res2
call Sub_800_LONGOP
push offset Arr2
push offset Res2
push 800
call StrHex_MY
invoke MessageBoxA, 0, ADDR Arr2, ADDR Caption2, 0

invoke ExitProcess, 0
end main