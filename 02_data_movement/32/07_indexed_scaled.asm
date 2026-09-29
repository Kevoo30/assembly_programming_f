section .data
    num1   db 120;
    num2   db 10;
    result db 0;

section .text
    global _start

_start:
;  add [num1],[num2]
    mov al, [num1]
    add al, [num2]
    mov [result], al

    jmp n_break

n_break:
    mov eax, 1
    xor ebx,ebx
    int 0x80