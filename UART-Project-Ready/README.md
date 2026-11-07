# UART Transmitter and Receiver — Verilog RTL

This repository is my small RTL project for understanding how a byte moves between parallel logic and a serial line. I built the transmitter and receiver as separate modules, then connected them in simulation to check that the byte sent by TX is the byte recovered by RX.

> **Scope:** RTL design and simulation. This repository does not claim a board-level FPGA implementation or physical UART testing.

## What the design does

- Sends and receives **8-bit UART data** using **8N1 framing** (1 start bit, 8 data bits, no parity, 1 stop bit).
- Sends the least-significant data bit first, as UART does.
- Uses separate finite-state machines for TX and RX.
- Uses a two-register synchronizer on the receiver input.
- Checks the start bit at its midpoint and reports a framing error if the stop bit is low.
- Lets the clock frequency and baud rate be set through Verilog parameters.

## Project map

```text
UART-Project-Ready/
├── src/
│   ├── uart_tx.v             # Transmitter
│   └── uart_rx.v             # Receiver
├── tb/
│   ├── tb_uart_tx.v          # TX-focused test
│   ├── tb_uart_rx.v          # RX-focused test
│   └── tb_uart_loopback.v    # TX connected to RX; byte comparisons
├── scripts/
│   ├── run_sim.sh             # Linux / Kali / Ubuntu
│   └── run_sim.ps1            # Windows PowerShell
├── docs/
│   ├── DESIGN.md              # FSM and timing explanation
│   └── TESTING.md             # How to run and read results
├── .github/workflows/rtl.yml   # Runs simulations on GitHub Actions
└── .gitignore
```

## Quick start

### Install the simulator

Install **Icarus Verilog** (`iverilog` and `vvp`). On Kali or Ubuntu:

```bash
sudo apt update
sudo apt install iverilog gtkwave
```

### Run the tests

Linux:

```bash
chmod +x scripts/run_sim.sh
./scripts/run_sim.sh
```

Windows PowerShell (from the project folder, with Icarus Verilog on PATH):

```powershell
.\scripts\run_sim.ps1
```

The script compiles and runs the TX test, RX test, and loopback test. The loopback test checks ten values (`00`, `FF`, `A5`, `3C`, `81`, `7E`, `55`, `AA`, `01`, `80`) and prints a pass/fail summary. A successful loopback run ends with `ALL TESTS PASSED`.

## See the serial frame

The loopback simulation writes `sim/uart_loopback.vcd`. Open it with GTKWave:

```bash
gtkwave sim/uart_loopback.vcd
```

Look for `tx`, `tx_start`, `tx_data`, `rx_data`, and `rx_done`. A frame should look like:

```text
Line:  idle | start | d0 | d1 | d2 | d3 | d4 | d5 | d6 | d7 | stop | idle
Level:   1 |   0   |       data (LSB first)       |  1  |  1
```

## Parameters used in loopback

| Parameter | Value | Meaning |
|---|---:|---|
| `CLK_FREQ` | 1,000,000 Hz | Simulation clock |
| `BAUD_RATE` | 100,000 | Serial bit rate |
| Clocks per bit | 10 | `CLK_FREQ / BAUD_RATE` |
| Frame length | 10 bits | Start + 8 data + stop |

These values keep simulation short. They are not a claim that a physical board was configured at these settings.

## Design flow

1. Write the TX and RX RTL modules.
2. Compile each module with its focused testbench.
3. Connect TX output to RX input for an end-to-end check.
4. Compare transmitted and received bytes in the testbench.
5. Inspect the VCD waveform when a signal or timing result needs closer review.

More detail: [Design notes](docs/DESIGN.md) · [Testing guide](docs/TESTING.md)

## Current limitations / next steps

- The baud divider uses integer division; fractional baud-rate generation is not included.
- The receiver has no FIFO, parity support, or configurable data width.
- The loopback is simulated; external serial hardware and FPGA pin constraints have not been tested here.
- Useful next additions would be configurable parity, a small RX FIFO, and tests for malformed frames and baud mismatch.

## Notes for review

The source is intentionally kept in two readable modules rather than hiding the behavior behind a large framework. The state names and counters can be followed directly in `src/uart_tx.v` and `src/uart_rx.v`. Please run the included scripts before treating the simulation result as verified on your machine.
