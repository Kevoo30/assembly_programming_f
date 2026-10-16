section .data
    numbers dd 10, 20, 30, 40, 50

section .text
    global _start

_start:
    mov ebx, numbers
    mov esi, 4

    mov eax, [ebx + esi]

    mov ecx, eax

n_break:
    mov eax, 1
    xor ebx, ebx
    int 0x80
