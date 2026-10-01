# Addition and EFLAGS

## Program: add

```asm
mov al, [num1]       ; num1 = 120 (01111000b)
add al, [num2]       ; num2 = 10  (00001010b)
mov [result], al
n_break:
```

```
  01111000   (120)
+ 00001010   (10)
------------
  10000010   (130, or -126 as a signed byte)
```

To check the flags in GDB:

```
(gdb) break n_break
(gdb) run
(gdb) info registers eflags
```

`mov` does not change any flags, so the flags at `n_break` come from the `add`.

GDB shows: `[ PF AF SF IF OF ]`

## Flags

| Flag | Status |
|------|--------|
| CF | Cleared |
| ZF | Cleared |
| SF | Set |
| OF | Set |
| PF | Set |
| AF | Set |

(`IF` is the interrupt flag. The operating system keeps it on, and it has nothing to do with the addition.)

## Why

**CF (Carry Flag) is cleared.** The unsigned result, 120 + 10 = 130, fits in 8 bits (0–255), so nothing carried out of bit 7.

**ZF (Zero Flag) is cleared.** The result `10000010` is not zero.

**SF (Sign Flag) is set.** SF copies the most significant bit of the result. Bit 7 of `10000010` is 1.

**OF (Overflow Flag) is set.** Treated as signed numbers, 120 and 10 are both positive, but the result looks negative (-126). The true answer, +130, is above the signed 8-bit maximum of +127. Two positives that give a negative means signed overflow.

**PF (Parity Flag) is set.** PF looks at the low 8 bits of the result only. `10000010` has two 1 bits, which is an even count, so PF is 1.

**AF (Auxiliary Carry Flag) is set.** AF tracks a carry from bit 3 into bit 4. The low nibbles are `1000` + `1010` = `10010`, which carries into bit 4.

## Summary

CF and OF check different things. CF is for unsigned overflow and OF is for signed overflow. Here the unsigned result fits (CF = 0), but the signed result does not (OF = 1).