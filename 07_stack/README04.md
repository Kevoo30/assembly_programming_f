# Program 04: 32-bit Stack Frame and Local Variables

## 1. Overview

This program demonstrates how stack frames and local variables work in 32-bit x86 assembly language.

It uses the `EBP` register as a frame pointer and the `ESP` register as a stack pointer. The program reserves 8 bytes of stack memory for two local variables, stores values in them, retrieves those values, and restores the stack before returning.

The program uses the Linux 32-bit system call interface (`int 0x80`) to terminate execution.

## 2. Source Code

```asm
BITS 32
section .text
    global _start

_start:
    call work

    ; Linux i386 exit syscall
    mov eax, 1
    xor ebx, ebx
    int 0x80

work:
    push ebp
    mov ebp, esp
    sub esp, 8

    mov dword [ebp - 4], 100
    mov dword [ebp - 8], 200

    mov eax, [ebp - 4]
    mov ebx, [ebp - 8]
    nop

    mov esp, ebp
    pop ebp
    ret
```

## 3. Execution Flow

The program executes in the following sequence:

1. **Function call:** `call work` transfers execution to the `work` function and pushes the return address onto the stack.
2. **Save the previous frame pointer:** `push ebp` saves the previous value of EBP.
3. **Establish the stack frame:** `mov ebp, esp` makes EBP the reference point for accessing local variables.
4. **Allocate local variables:** `sub esp, 8` reserves 8 bytes of stack memory.
5. **Store local variables:** The values 100 and 200 are stored at `[ebp - 4]` and `[ebp - 8]`.
6. **Retrieve local variables:** The values are loaded into EAX and EBX respectively.
7. **Restore the stack:** `mov esp, ebp` releases the allocated local-variable space.
8. **Restore EBP:** `pop ebp` retrieves the previous frame pointer.
9. **Return:** `ret` retrieves the return address and transfers execution back to `_start`.
10. **Exit:** The program terminates using the Linux 32-bit exit system call.

## 4. Stack Frame Analysis

The stack frame contains the return address, the saved EBP, and two local variables.

```text
          Higher addresses
        +----------------------+
        | Return address       | [EBP + 4]
        +----------------------+
        | Previous EBP         | [EBP]
        +----------------------+ <-- EBP
        | Local variable 1     | [EBP - 4] = 100
        +----------------------+
        | Local variable 2     | [EBP - 8] = 200
        +----------------------+ <-- ESP
          Lower addresses
```

Each local variable occupies 4 bytes because this is a 32-bit program.

## 5. Testing and Execution Results

### Assembly and Linking

The program was assembled and linked using:

```bash
nasm -f elf32 04.asm -o 04.o
ld -m elf_i386 04.o -o 04
./04
```

### GDB Debugging

The program was inspected using GDB and the following registers:

- ESP – Stack pointer.
- EBP – Base/frame pointer.
- EAX – First retrieved local variable.
- EBX – Second retrieved local variable.

### Stack Pointer and Frame Pointer Observations

| Execution stage | ESP | EBP |
|---|---|---|
| Initial state | `0xffffc980` | `0x0` |
| After CALL | `0xffffc97c` | `0x0` |
| After PUSH EBP | `0xffffc978` | `0x0` |
| After MOV EBP, ESP | `0xffffc978` | `0xffffc978` |
| After SUB ESP, 8 | `0xffffc970` | `0xffffc978` |
| After MOV ESP, EBP | `0xffffc978` | `0xffffc978` |
| After POP EBP | `0xffffc97c` | `0x0` |
| After RET | `0xffffc980` | `0x0` |

### Register Values

After retrieving the local variables, GDB displayed:

| Register | Hexadecimal value | Decimal value |
|---|---|---|
| EAX | `0x64` | 100 |
| EBX | `0xc8` | 200 |

The observations confirm that both local variables were stored and retrieved correctly.

The stack pointer also returned to its initial value after the function returned.

### Program Termination

The program exited normally after executing the Linux 32-bit exit system call.

## 6. Conclusion

This program demonstrates how a 32-bit stack frame is created, used, and destroyed.

It shows how EBP provides a stable reference point for accessing local variables while ESP tracks the current top of the stack.

The program successfully stored and retrieved two local variables, restored the previous frame pointer, and returned to the calling function.