# 8-Bit ALU Design Using Verilog

## Project Overview
This project implements an 8-bit Arithmetic Logic Unit (ALU) using Verilog HDL. The ALU performs arithmetic and logical operations based on a 3-bit selection input.

The design is simulated using Icarus Verilog and verified using GTKWave.

## Features
- 8-bit input operands A and B
- 3-bit operation selection
- Arithmetic addition and subtraction
- Bitwise AND, OR, and XOR operations
- CarryOut output
- Zero flag detection
- Verilog testbench verification
- Waveform visualization

## ALU Operations

| Sel | Operation | Description |
|---|---|---|
| 000 | Addition | A + B |
| 001 | Subtraction | A - B |
| 010 | AND | A & B |
| 011 | OR | A \| B |
| 100 | XOR | A ^ B |
| Others | Default | Result = 0 |

## Hardware Interface

| Signal | Width | Description |
|---|---:|---|
| A | 8-bit | First operand |
| B | 8-bit | Second operand |
| Sel | 3-bit | Operation selector |
| Result | 8-bit | ALU output |
| CarryOut | 1-bit | Carry output |
| Zero | 1-bit | Zero flag |

## Project Structure

```text
8-Bit-ALU-Design/
├── src/
│   └── alu.v
├── testbench/
│   └── tb_alu.v
├── results/
│   └── alu.vcd
├── README.md
└── alu_tb
```

## Tools Used
- Verilog HDL
- Visual Studio Code
- Icarus Verilog
- GTKWave

## Simulation Results

| Operation | Input A | Input B | Result |
|---|---:|---:|---:|
| Addition | 15 | 10 | 25 |
| Subtraction | 20 | 5 | 15 |
| AND | CC | AA | 88 |
| OR | CC | AA | EE |
| XOR | CC | AA | 66 |
| Zero Test | 0 | 0 | 0 |

## How to Run

### Compile
```bash
iverilog -g2012 -o alu_tb src/alu.v testbench/tb_alu.v
```

### Run Simulation
```bash
vvp alu_tb
```

### View Waveforms
```bash
gtkwave results/alu.vcd
```

## Learning Outcomes
- Understanding combinational digital logic
- Implementing arithmetic and logical operations using Verilog
- Writing and executing testbenches
- Verifying digital designs using waveform analysis

## Author
Developed as a digital design project using Verilog HDL.