# Division and EFLAGS

## Program 1: div1.asm (100 / 7)

```asm
mov ax, [dividend]   ; ax = 100
mov bl, [divisor]    ; bl = 7
div bl               ; al = 14 (quotient), ah = 2 (remainder)
```

`div bl` divides AX by BL. The quotient goes in AL and the remainder in AH.

- 100 / 7 = 14 remainder 2
- AL = 14 (`00001110`)
- AH = 2 (`00000010`)

## Flags

After `div bl`, the flags in GDB were `[ AF IF ]`. Before it they were `[ IF ]`.

| Flag | Status |
|------|--------|
| CF | Cleared |
| ZF | Cleared |
| SF | Cleared |
| OF | Cleared |
| PF | Cleared |
| AF | Set |

`IF` is the interrupt flag. The operating system keeps it on, and it has nothing to do with the division.

## Why

**All six flags are undefined after `div`.** The Intel manual states that CF, OF, SF, ZF, AF and PF are undefined after `div`. The CPU makes no promise about their values, so what GDB shows is leftover state, not information about the division.

**CF (Carry Flag) is cleared, but it says nothing about the result.** After `add`, CF reports an unsigned carry. `div` does not update it. A quotient that is too big for AL is not reported through CF either: it raises a divide error (`SIGFPE`).

**ZF (Zero Flag) is cleared, but it does not tell us the result is non-zero.** The quotient is 14 and the remainder is 2, but `div` does not set ZF from either of them.

**SF (Sign Flag) is cleared, but it does not reflect the quotient.** After `add` or `sub`, SF copies the top bit of the result. `div` does not do this.

**OF (Overflow Flag) is cleared, but it does not report overflow.** Division overflow, such as a quotient that does not fit in AL or a divisor of 0, causes a divide error instead of setting OF.

**PF (Parity Flag) is cleared, but it is not computed from the result.** The quotient `00001110` has three 1 bits, which would mean odd parity, but `div` does not calculate PF, so this agreement is only a coincidence.

**AF (Auxiliary Carry Flag) changed from cleared to set, but the result does not cause it.** Nothing in 100 / 7 produces a carry from bit 3 into bit 4. The CPU is allowed to set, clear or leave AF after `div`, and this processor happened to set it. Unlike `add`, where AF is set because of a real carry, this change cannot be explained from the numbers.

## Summary

Unlike `add`, `sub` and `mul`, `div` does not report anything through EFLAGS. To branch on a division result, run `test al, al` or `cmp` afterwards, which set the flags properly.