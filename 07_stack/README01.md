# 01 - Basic Stack Operations (PUSH and POP)

## 1. Overview

This program demonstrates the basic operations of the stack in x86-64 assembly language. It illustrates how values are stored using the `PUSH` instruction and retrieved using the `POP` instruction.

The stack follows the **Last In, First Out (LIFO)** principle, meaning the last value pushed onto the stack is the first one removed.

## 2. Source Code

```asm
section .text
    global _start

_start:
    mov rax, 100
    mov rbx, 200

    push rax
    push rbx
    nop

    pop rcx
    pop rdx
    nop

    mov rax, 60
    xor rdi, rdi
    syscall
```

## 3. Execution Flow

### Step 1: Register Initialization

```asm
mov rax, 100
mov rbx, 200
```

Two values are initialized in the registers:

| Register | Value |
|:---|---:|
| RAX | 100 |
| RBX | 200 |

At this point, no stack operations have taken place.

### Step 2: Pushing Values onto the Stack

```asm
push rax
push rbx
nop
```

- `PUSH RAX` places 100 onto the stack.
- `PUSH RBX` places 200 onto the stack.
- `NOP` performs no operation.

Each PUSH operation decreases RSP by 8 bytes because the program uses 64-bit registers.

**Stack arrangement after both PUSH operations:**

```text
       STACK (64-bit)

    Higher memory addresses
    ┌──────────────────┐
    │       100        │
    ├──────────────────┤
    │       200        │  ← RSP (Top of Stack)
    └──────────────────┘
    Lower memory addresses
```

The value 200 is now at the top of the stack because it was pushed last.

### Step 3: Popping Values from the Stack

```asm
pop rcx
pop rdx
nop
```

- `POP RCX` retrieves 200 and stores it in RCX.
- `POP RDX` retrieves 100 and stores it in RDX.
- `NOP` performs no operation.

After the POP operations:

| Register | Retrieved Value |
|:---|---:|
| RCX | 200 |
| RDX | 100 |

This demonstrates the LIFO principle: the last value pushed (200) is the first value popped.

After both values are removed, the stack pointer returns to its original position.

### Step 4: Program Termination

```asm
mov rax, 60
xor rdi, rdi
syscall
```

- `MOV RAX, 60` selects the Linux exit system call.
- `XOR RDI, RDI` sets the exit status to zero.
- `SYSCALL` executes the system call and terminates the program.

## 4. Stack Pointer (RSP) Analysis

The program was inspected using GDB to observe changes in the RSP register.

The initial stack pointer was:

`0x7fffffffd810`

The following changes were observed during execution:

| Instruction | RSP Address | Change |
|:---|:---|:---|
| Initial state | `0x7fffffffd810` | Initial position |
| `PUSH RAX` | `0x7fffffffd808` | -8 bytes |
| `PUSH RBX` | `0x7fffffffd800` | -8 bytes |
| `POP RCX` | `0x7fffffffd808` | +8 bytes |
| `POP RDX` | `0x7fffffffd810` | +8 bytes |

**Observations:**

- PUSH decreases RSP by 8 bytes.
- POP increases RSP by 8 bytes.
- NOP does not affect the stack pointer.
- After both POP operations, RSP returns to its initial address.

## 5. Testing and Execution Results

The program was assembled, linked and executed using NASM and the Linux linker.

**Commands used:**

```bash
nasm -f elf64 01.asm -o 01.o
ld 01.o -o 01
./01
echo $?
```

**Execution observations:**

| Test | Result |
|:---|:---|
| Assembly | Successful |
| Linking | Successful |
| Execution | Successful |
| Exit status | `0` |
| Visible output | None |

The program produces no visible output because it does not contain any instructions for displaying information on the terminal.

GDB was also used to execute the program one instruction at a time and observe the changes in RSP.

## 6. Conclusion

This program demonstrates the fundamental operation of the stack using PUSH and POP instructions.

It confirms that the stack follows the Last In, First Out (LIFO) principle. It also demonstrates that the stack grows towards lower memory addresses, causing RSP to decrease during PUSH operations and increase during POP operations.

After all values are retrieved, the original stack pointer is restored.

The program provides a practical demonstration of how data is temporarily stored and retrieved using the stack in x86-64 assembly language.