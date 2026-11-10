# Program 05: 64-bit Stack Operations with Hexadecimal Values

## 1. Overview

This program demonstrates stack operations in 64-bit x86 assembly using hexadecimal values.

It uses the PUSH and POP instructions to store and retrieve values from the stack. The program demonstrates the Last In, First Out (LIFO) principle, where the last value pushed onto the stack is the first value removed.

Two 64-bit registers, RAX and RBX, are used to demonstrate how values are preserved and restored through stack operations.

## 2. Source Code

```asm
section .text
    global _start

_start:
    mov rax, 0x1122334455667788
    mov rbx, 0x1234

    push rax
    push rbx
    nop

    pop rbx
    pop rax

    mov rax, 60
    xor rdi, rdi
    syscall
```

## 3. Execution Flow

The program executes in the following sequence:

1. **Initialize RAX:** Stores the hexadecimal value `0x1122334455667788` in RAX.
2. **Initialize RBX:** Stores the hexadecimal value `0x1234` in RBX.
3. **Push RAX:** Places the 64-bit value in RAX onto the stack. RSP decreases by 8 bytes.
4. **Push RBX:** Places the 64-bit value in RBX onto the stack. RSP decreases by another 8 bytes.
5. **NOP:** Performs no operation and provides a convenient point for observing the stack.
6. **Pop RBX:** Retrieves the most recently pushed value from the stack and restores it into RBX.
7. **Pop RAX:** Retrieves the remaining value and restores it into RAX.
8. **Exit:** Uses the Linux 64-bit exit system call to terminate the program with status 0.

## 4. Stack Analysis

The stack grows towards lower memory addresses.

After both PUSH instructions, the stack contains:

```text
          Higher addresses
       +--------------------------+
       | RAX = 0x1122334455667788 |
       +--------------------------+
       | RBX = 0x0000000000001234 | <-- RSP
       +--------------------------+
          Lower addresses
```

The stack uses the Last In, First Out (LIFO) principle. Therefore, RBX is popped first, followed by RAX.

### Stack Pointer Analysis

The following values were observed during GDB debugging:

| Execution stage | RSP |
|---|---|
| Initial state | `0x7fffffffd810` |
| After PUSH RAX | `0x7fffffffd808` |
| After PUSH RBX | `0x7fffffffd800` |
| After NOP | `0x7fffffffd800` |
| After POP RBX | `0x7fffffffd808` |
| After POP RAX | `0x7fffffffd810` |

The stack pointer returned to its original value after both POP instructions.

## 5. Testing and Execution Results

### Assembly and Linking

The program was assembled and linked using:

```bash
nasm -f elf64 05.asm -o 05.o
ld 05.o -o 05
./05
```

### GDB Debugging

The program was inspected using GDB with the following registers:

- RSP – Tracks the current top of the stack.
- RAX – Holds the first 64-bit hexadecimal value.
- RBX – Holds the second 64-bit hexadecimal value.

### Register Values

The following values were observed during debugging:

| Register | Hexadecimal value | Description |
|---|---|---|
| RAX | `0x1122334455667788` | Original value successfully restored |
| RBX | `0x1234` | Original value successfully restored |

After the POP instructions, both registers contained their original values.

Before program termination, RAX was changed to `0x3c` (60 decimal), representing the Linux exit system call number.

### Program Termination

GDB confirmed that the program exited normally.

## 6. Conclusion

This program demonstrates how 64-bit values are stored and retrieved using the stack in x86-64 assembly.

It confirms that each PUSH and POP operation adjusts the stack pointer by 8 bytes and demonstrates the Last In, First Out (LIFO) principle.

Both original register values were successfully restored, and the stack pointer returned to its initial position.