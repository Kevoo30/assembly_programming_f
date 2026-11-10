# Program 03: CALL and RET Instructions

## 1. Overview

This program demonstrates how the `CALL` and `RET` instructions work in x86-64 assembly.

The `CALL` instruction transfers execution to a procedure and pushes the return address onto the stack. The `RET` instruction retrieves that address and returns execution to the instruction immediately after the original `CALL`.

The program also demonstrates how a procedure can modify a register and return the result to the calling procedure.

## 2. Source Code

```asm
section .text
    global _start

_start:
    mov rax, 10
    call calculate

after_call:
    ; RAX should now be 15
    nop

    mov rax, 60
    xor rdi, rdi
    syscall

calculate:
    add rax, 5
    ret
```

## 3. Execution Flow

1. `mov rax, 10` stores 10 in the RAX register.
2. `call calculate` transfers execution to the `calculate` procedure and pushes the return address onto the stack.
3. `add rax, 5` adds 5 to the value in RAX, changing it from 10 to 15.
4. `ret` retrieves the saved return address and transfers execution back to `after_call`.
5. `nop` performs no operation.
6. `mov rax, 60` selects the Linux exit system call.
7. `xor rdi, rdi` sets the exit status to 0.
8. `syscall` terminates the program.

## 4. Stack Pointer Analysis

The stack grows downwards in memory. When `CALL` pushes the return address onto the stack, RSP decreases by 8 bytes because this is a 64-bit program.

### Stack behaviour

**Before CALL:**

```text
RSP = 0x7fffffffd810
```

**After CALL:**

```text
RSP = 0x7fffffffd808
+--------------------------+
| Return address           |
| 0x40100a                 |
+--------------------------+
```

**After RET:**

```text
RSP = 0x7fffffffd810
```

The `RET` instruction removes the saved return address from the stack and restores the original stack pointer.

### GDB observations

| Execution stage | RSP | RAX |
|---|---|---|
| At `_start` | `0x7fffffffd810` | `0x0` |
| After `mov rax, 10` | `0x7fffffffd810` | `0xa` |
| After `call calculate` | `0x7fffffffd808` | `0xa` |
| After `add rax, 5` | `0x7fffffffd808` | `0xf` |
| After `ret` | `0x7fffffffd810` | `0xf` |
| After returning to `after_call` | `0x7fffffffd810` | `0xf` |

**Register values:**
- `0xa` represents decimal 10.
- `0xf` represents decimal 15.
- RSP decreases by 8 bytes after `CALL`.
- RSP increases by 8 bytes after `RET`.

## 5. Testing and Execution Results

The program was assembled, linked and executed successfully using NASM, the GNU linker and GDB.

GDB confirmed that:
- The `CALL` instruction pushed the return address onto the stack.
- RSP decreased from `0x7fffffffd810` to `0x7fffffffd808`.
- The `ADD` instruction changed RAX from 10 to 15.
- The `RET` instruction restored RSP to `0x7fffffffd810`.
- Execution returned to the `after_call` label.
- The program exited normally with status 0.

## 6. Conclusion

This program demonstrates the relationship between procedure calls and the stack in x86-64 assembly.

The `CALL` instruction saves the return address on the stack, while `RET` retrieves it to resume execution at the correct location. The program also demonstrates that register values can be modified inside a procedure and remain available after returning.

