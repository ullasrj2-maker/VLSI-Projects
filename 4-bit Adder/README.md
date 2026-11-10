# 4-Bit Ripple-Carry Adder (Verilog)

A structural 4-bit ripple-carry adder built from four 1-bit full-adder stages. This repository demonstrates **digital logic RTL and exhaustive simulation**; it is not a transistor-level CMOS schematic/layout.

## Features
- Four full-adder stages connected in a ripple-carry chain
- 4-bit inputs `A` and `B`, plus carry-in `Cin`
- 4-bit result `Sum` and carry-out `Cout`
- Exhaustive self-checking testbench covering all 512 input combinations
- VCD waveform output

## Files
| File | Purpose |
|---|---|
| `full_adder.v` | 1-bit full-adder logic |
| `four_bit_adder.v` | Structural 4-bit ripple-carry adder |
| `tb_four_bit_adder.v` | Exhaustive testbench |

## Architecture
Each stage calculates `Sum = A XOR B XOR Cin` and `Cout = (A AND B) OR (A AND Cin) OR (B AND Cin)`. Carry ripples from bit 0 through bit 3.

```text
A[0], B[0], Cin -> FA0 -> c1
A[1], B[1], c1   -> FA1 -> c2
A[2], B[2], c2   -> FA2 -> c3
A[3], B[3], c3   -> FA3 -> Cout
                         outputs: Sum[3:0]
```

## Run with Icarus Verilog
From this folder:
```bash
iverilog -g2012 -o adder_sim full_adder.v four_bit_adder.v tb_four_bit_adder.v
vvp adder_sim
```
Expected output: `PASS: all 512 input combinations verified.`

Open waveform using GTKWave:
```bash
gtkwave four_bit_adder.vcd
```

## Verification details
The testbench checks `A=0..15`, `B=0..15`, and `Cin=0..1`: `16 × 16 × 2 = 512` combinations. For each input, `{Cout, Sum}` is compared with `A + B + Cin`. A mismatch triggers `$fatal`; PASS appears only after every case succeeds.

## Example
For `A=1111 (15)`, `B=0001 (1)`, `Cin=0`, output is `Cout=1`, `Sum=0000` (5-bit result `10000`, decimal 16).

## Scope and limitations
This is a digital RTL/structural logic project. It does **not** include transistor sizing, CMOS schematics, SPICE analysis, physical layout, or LVS/DRC. A transistor-level CMOS course submission requires additional schematic/layout work using a suitable PDK flow.

## Extensions
- Compare ripple carry with carry-lookahead
- Measure and compare propagation delay
- Design and validate a transistor-level CMOS full-adder cell separately
