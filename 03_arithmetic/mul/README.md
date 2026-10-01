# Multiplication and EFLAGS

## Program 1: mul_byte.asm (25 * 10)

```asm
mov al, [num1]      ; al = 25
mul byte [num2]     ; ax = al * 10 = 250
mov [result], ax    ; store result in memory
```

`mul byte [num2]` multiplies AL by the byte in memory (unsigned) and puts the 16-bit product in AX.

- 25 * 10 = 250
- AX = `0x00FA` (`00000000 11111010`)
- AH = 0 (upper half), AL = 250 (lower half)

## Flags

| Flag | Status |
|------|--------|
| CF | Cleared |
| OF | Cleared |
| SF | Undefined |
| ZF | Undefined |
| PF | Undefined |
| AF | Undefined |

## Why

**CF (Carry Flag) is cleared.** After `mul`, CF is set when the upper half of the product is non-zero. The product 250 fits in AL (0–255), so AH = 0 and CF = 0. It means no significant bits were lost by looking only at AL.

**OF (Overflow Flag) is cleared.** OF follows the same rule as CF for `mul`. AH is 0, so the full result fits in the lower half and OF = 0. Note that `mul` is unsigned: AL = `11111010` would be -6 if read as signed, but that does not matter here, because `mul` only checks whether AH is zero.

**SF (Sign Flag) is undefined.** The Intel manual says SF is undefined after `mul`. It is not copied from the top bit of the product, so it says nothing about the sign of 250.

**ZF (Zero Flag) is undefined.** `mul` does not set ZF from the result. The product is 250, not zero, but ZF cannot be used to tell that.

**PF (Parity Flag) is undefined.** `mul` does not calculate PF. The low byte `11111010` has six 1 bits (even parity), but if PF happens to show as set, that is a coincidence, not a result of the multiplication.

**AF (Auxiliary Carry Flag) is undefined.** `mul` does not calculate AF from any carry between bit 3 and bit 4.

## Summary

After `mul`, only CF and OF carry information: both are 1 if the product spilled into the upper half, and both are 0 if it fits in the lower half. Here 250 fits in AL, so both are cleared. The other four flags should not be relied on.