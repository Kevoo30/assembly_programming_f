# 02 - Stack Frames and Local Variables

## 1. Overview

This program demonstrates how stack frames are created and managed in x86-64 assembly language.

It introduces the use of function calls, base pointers, stack pointers and local variables stored in stack memory.

The program uses the `CALL`, `PUSH`, `MOV`, `SUB`, `POP` and `RET` instructions to demonstrate how a function manages its own stack space.

## 2. Source Code

```asm
section .text
    global _start

_start:
    call work
    mov rax, 60
    xor rdi, rdi
    syscall

work:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov qword [rbp - 8], 100
    mov qword [rbp - 16], 200

    mov rax, [rbp - 8]
    mov rbx, [rbp - 16]
    nop

    mov rsp, rbp
    pop rbp
    ret
```

## 3. Execution Flow

### Step 1: Function Call

```asm
call work
```

The CALL instruction transfers execution to the `work` function.

Before transferring control, the processor automatically pushes the return address onto the stack.

Since the program is 64-bit, the return address occupies 8 bytes.

### Step 2: Creating the Stack Frame

```asm
push rbp
mov rbp, rsp
sub rsp, 16
```

These instructions prepare the stack frame.

- `PUSH RBP`: Saves the previous base pointer on the stack.
- `MOV RBP, RSP`: Establishes RBP as the reference point for the current stack frame.
- `SUB RSP, 16`: Allocates 16 bytes of memory for local variables.

The stack pointer decreases by 8 bytes when RBP is pushed and another 16 bytes when space is allocated.

### Step 3: Storing Local Variables

```asm
mov qword [rbp - 8], 100
mov qword [rbp - 16], 200
```

The program stores two local variables in the allocated stack memory.

| Memory Location | Value | Size |
|:---|---:|---:|
| `[RBP - 8]` | 100 | 8 bytes |
| `[RBP - 16]` | 200 | 8 bytes |

The `QWORD` keyword specifies that each memory location occupies 8 bytes (64 bits).

### Step 4: Retrieving Local Variables

```asm
mov rax, [rbp - 8]
mov rbx, [rbp - 16]
nop
```

The values stored in the local variables are retrieved into CPU registers.

- RAX receives 100.
- RBX receives 200.
- NOP performs no operation.

The values remain stored in stack memory until the stack frame is released.

### Step 5: Restoring the Stack Frame

```asm
mov rsp, rbp
pop rbp
ret
```

These instructions clean up the stack frame and return execution to the calling function.

- `MOV RSP, RBP`: Releases the 16 bytes allocated for local variables.
- `POP RBP`: Restores the previous base pointer.
- `RET`: Retrieves the saved return address and transfers execution back to `_start`.

After RET, RSP returns to its original value.

### Step 6: Program Termination

```asm
mov rax, 60
xor rdi, rdi
syscall
```

The program uses the Linux exit system call to terminate execution.

RAX is set to 60, RDI is cleared to zero, and SYSCALL executes the exit operation.

## 4. Stack Frame Structure

After allocating space for local variables, the stack is arranged as follows:

```text
        HIGHER MEMORY ADDRESSES
        ┌────────────────────────┐
        │     Return Address     │
        ├────────────────────────┤
        │       Saved RBP        │
        ├────────────────────────┤
        │     Local Variable     │
        │          100           │
        │       [RBP - 8]        │
        ├────────────────────────┤
        │     Local Variable     │
        │          200           │
        │       [RBP - 16]       │
        └────────────────────────┘
                  ↑
                 RSP
        LOWER MEMORY ADDRESSES
```

RBP provides a fixed reference point for accessing local variables, while RSP identifies the current top of the stack.

## 5. Stack Pointer (RSP) Analysis

The program was inspected using GDB to observe changes in RSP and RBP.

The initial register values were:

- RSP = `0x7fffffffd810`
- RBP = `0x0`

The following changes were observed:

| Instruction | RSP Address | RBP Address |
|:---|:---|:---|
| Initial state | `0x7fffffffd810` | `0x0` |
| CALL work | `0x7fffffffd808` | `0x0` |
| PUSH RBP | `0x7fffffffd800` | `0x0` |
| MOV RBP, RSP | `0x7fffffffd800` | `0x7fffffffd800` |
| SUB RSP, 16 | `0x7fffffffd7f0` | `0x7fffffffd800` |
| MOV RSP, RBP | `0x7fffffffd800` | `0x7fffffffd800` |
| POP RBP | `0x7fffffffd808` | `0x0` |
| RET | `0x7fffffffd810` | `0x0` |

### Observations

1. CALL automatically decreases RSP by 8 bytes.
2. PUSH RBP decreases RSP by another 8 bytes.
3. SUB RSP, 16 reserves 16 bytes for local variables.
4. RBP remains constant while local variables are accessed.
5. MOV RSP, RBP releases the allocated local variable space.
6. POP RBP restores the previous base pointer.
7. RET removes the return address and restores the original RSP.

## 6. Testing and Execution Results

The program was assembled, linked and executed using NASM and the Linux linker.

**Commands used:**

```bash
nasm -f elf64 02.asm -o 02.o
ld 02.o -o 02
./02
echo $?
```

GDB was used to step through the program and inspect the stack pointer and base pointer.

### Register observations

| Register | Hexadecimal Value | Decimal Value |
|:---|---:|---:|
| RAX | `0x64` | 100 |
| RBX | `0xc8` | 200 |
| RBP (after restoration) | `0x0` | 0 |

The program executed normally and returned to `_start`.

The program produces no visible terminal output because it does not contain printing instructions.

## 7. Conclusion

This program demonstrates how stack frames are created and managed during function execution in x86-64 assembly language.

It shows how CALL saves a return address, how PUSH RBP saves the previous base pointer, and how RBP provides a reference for accessing local variables.

It also demonstrates how stack memory is allocated using SUB RSP, 16 and released using MOV RSP, RBP.

Finally, the POP and RET instructions restore the previous stack state and return execution to the calling function.
