# Program 06: 32-bit Stack Operations with Hexadecimal Values

## 1. Overview

This program demonstrates stack operations in 32-bit x86 assembly using hexadecimal values.

It uses the PUSH and POP instructions to store and retrieve values from the stack. The program demonstrates the Last In, First Out (LIFO) principle, where the last value pushed onto the stack is the first value removed.

The program uses the 32-bit registers EAX and EBX and the ESP register to demonstrate how values are preserved and restored through stack operations.

## 2. Source Code

```asm
BITS 32
section .text
    global _start

_start:
    mov eax, 0x11223344
    mov ebx, 0x1234

    push eax
    push ebx
    nop

    pop ebx
    pop eax

    mov eax, 1
    xor ebx, ebx
    int 0x80
```

## 3. Execution Flow

The program executes in the following sequence:

1. **Initialize EAX:** Stores the hexadecimal value `0x11223344` in EAX.
2. **Initialize EBX:** Stores the hexadecimal value `0x1234` in EBX.
3. **Push EAX:** Places the value in EAX onto the stack. ESP decreases by 4 bytes.
4. **Push EBX:** Places the value in EBX onto the stack. ESP decreases by another 4 bytes.
5. **NOP:** Performs no operation and provides a convenient point for observing the stack.
6. **Pop EBX:** Retrieves the most recently pushed value and restores it into EBX.
7. **Pop EAX:** Retrieves the remaining value and restores it into EAX.
8. **Exit:** Uses the Linux 32-bit exit system call to terminate the program with status 0.

## 4. Stack Analysis

The stack grows towards lower memory addresses.

After both PUSH instructions, the stack contains:

```text
          Higher addresses
       +----------------------+
       | EAX = 0x11223344     |
       +----------------------+
       | EBX = 0x00001234     | <-- ESP
       +----------------------+
          Lower addresses
```

The stack follows the Last In, First Out (LIFO) principle. Therefore, EBX is popped first, followed by EAX.

Each value occupies 4 bytes because this is a 32-bit program.

### Stack Pointer Analysis

The following values were observed during GDB debugging:

| Execution stage | ESP |
|---|---|
| Initial state | `0xffffc980` |
| After PUSH EAX | `0xffffc97c` |
| After PUSH EBX | `0xffffc978` |
| After NOP | `0xffffc978` |
| After POP EBX | `0xffffc97c` |
| After POP EAX | `0xffffc980` |

The stack pointer returned to its original value after both POP instructions.

## 5. Testing and Execution Results

### Assembly and Linking

The program was assembled and linked using:

```bash
nasm -f elf32 06.asm -o 06.o
ld -m elf_i386 06.o -o 06
./06
```

### GDB Debugging

The program was inspected using GDB with the following registers:

- ESP – Tracks the current top of the stack.
- EAX – Holds the first 32-bit hexadecimal value.
- EBX – Holds the second 32-bit hexadecimal value.

### Register Values

The following values were observed during debugging:

| Register | Hexadecimal value | Description |
|---|---|---|
| EAX | `0x11223344` | Original value successfully restored |
| EBX | `0x1234` | Original value successfully restored |

After the POP instructions, both registers contained their original values.

Before program termination, EAX was changed to `0x1` (1 decimal), representing the Linux 32-bit exit system call number.

### Program Termination

GDB confirmed that the program exited normally.

## 6. Conclusion

This program demonstrates how 32-bit hexadecimal values are stored and retrieved using the stack in x86 assembly.

It confirms that each PUSH and POP operation adjusts the stack pointer by 4 bytes and demonstrates the Last In, First Out (LIFO) principle.

Both original register values were successfully restored, and the stack pointer returned to its initial position.