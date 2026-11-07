# Testing and waveform guide

## Test files

- `tb_uart_tx.v` exercises the transmitter by itself.
- `tb_uart_rx.v` exercises the receiver with a serial stimulus.
- `tb_uart_loopback.v` wires TX directly into RX and compares each received byte with the input byte.

## Run

Use `./scripts/run_sim.sh` on Linux/Kali/Ubuntu or `scripts/run_sim.ps1` in PowerShell on Windows. Both require `iverilog` and `vvp` available on PATH.

The loopback test checks ten byte patterns. Each line marked `[PASS]` means the received byte matched and `rx_error` was low. The final summary should report ten passes, zero failures, and `ALL TESTS PASSED`.

## Inspect a VCD

The loopback test writes `sim/uart_loopback.vcd`. Open it in GTKWave and add these signals:

- `tx_start` and `tx_data` — parallel request to the transmitter
- `tx` — serial frame
- `rx_data` — recovered byte
- `rx_done` — one-cycle receive completion pulse
- `rx_error` — stop-bit/framing indication

A valid 8N1 frame is idle-high, start-low, eight LSB-first data bits, and stop-high.

## What simulation does not establish

Passing these tests is evidence for the tested RTL behavior and parameter values only. It does not establish synthesis quality, FPGA timing closure, electrical signal integrity, or operation with a physical USB-to-UART adapter.
