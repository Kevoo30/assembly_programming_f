# Subtraction and EFLAGS

## Program 1: sub1.asm (50 - 80)

```asm
mov al, [num1]       ; al = 50 (00110010)
sub al, [num2]       ; al = 50 - 80, num2 = 80 (01010000)
mov [result], al
```

```
  00110010   (50)
- 01010000   (80)
------------
  11100010   (0xE2, which is 226 unsigned or -30 signed)
```

## Flags

| Flag | Status |
|------|--------|
| CF | Set |
| ZF | Cleared |
| SF | Set |
| OF | Cleared |
| PF | Set |
| AF | Cleared |

## Why

**CF (Carry Flag) is set.** For `sub`, CF means a borrow. Treated as unsigned numbers, 50 is less than 80, so the subtraction has to borrow from beyond bit 7. The stored result 226 is 256 - 30, which shows the wrap-around.

**ZF (Zero Flag) is cleared.** The result `11100010` is not zero, because 50 and 80 are different.

**SF (Sign Flag) is set.** SF copies the most significant bit of the result. Bit 7 of `11100010` is 1, so the result is negative in signed representation (-30).

**OF (Overflow Flag) is cleared.** Treated as signed numbers, 50 - 80 = -30, which fits in a signed 8-bit value (-128 to 127). The result is correct, so there is no signed overflow. CF and OF are independent: here the unsigned borrow happened but the signed result is valid.

**PF (Parity Flag) is set.** PF looks at the low 8 bits of the result only. `11100010` has four 1 bits, which is an even count, so PF is 1.

**AF (Auxiliary Carry Flag) is cleared.** AF tracks a borrow from bit 4 into the low nibble. The low nibbles are `0010` - `0000` = `0010`, which needs no borrow, so AF is 0.

## Summary

Unsigned, 50 - 80 does not fit (CF = 1). Signed, 50 - 80 = -30 fits (OF = 0), and SF = 1 reports that the result is negative.