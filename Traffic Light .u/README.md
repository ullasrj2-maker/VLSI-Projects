# Traffic Light Controller (Verilog FSM)

A clock-driven, three-state traffic-light controller implemented as a finite-state machine (FSM) in Verilog. This repository demonstrates **digital RTL design and simulation**; it is not a physical traffic-light product.

## Features

- Three states: `GREEN`, `YELLOW`, and `RED`
- Parameterized state durations (`GREEN_CYCLES`, `YELLOW_CYCLES`, `RED_CYCLES`)
- Synchronous active-high reset; reset selects GREEN
- One-hot lamp outputs (only one output is high at a time)
- Testbench checks the expected state sequence and one-hot behavior
- VCD waveform output for signal inspection

## Files

| File | Purpose |
|---|---|
| `traffic_light_controller.v` | Synthesizable controller RTL |
| `tb_traffic_light_controller.v` | Simulation testbench |

## State sequence

`GREEN → YELLOW → RED → GREEN → ...`

The testbench uses short durations of 3, 2, and 3 clock cycles respectively. The RTL defaults are 5, 2, and 5 cycles. These are **clock-cycle counts**, not real-world seconds; a real timing design must select a clock frequency and suitable cycle counts.

## Run with Icarus Verilog

From this folder, run:

```bash
iverilog -g2012 -o traffic_sim traffic_light_controller.v tb_traffic_light_controller.v
vvp traffic_sim
```

Expected final messages:

```text
PASS: sequence GREEN -> YELLOW -> RED -> GREEN verified.
PASS: one-hot output checks completed (... checks).
Waveform: traffic_light_controller.vcd
```

Open the generated VCD with GTKWave:

```bash
gtkwave traffic_light_controller.vcd
```

If Icarus Verilog is unavailable, paste both source files into a compatible online Verilog simulator. Keep the module and testbench together.

## Verification performed

- Testbench checks reset to GREEN.
- Checks the GREEN → YELLOW → RED → GREEN sequence over two cycles.
- Checks that exactly one lamp output is asserted at each sampled state.
- Generates a VCD waveform for review.

## Design overview

The controller stores its current state and a cycle counter. On each rising clock edge, the counter advances; when the configured duration is reached, the FSM moves to the next state and resets the counter. A combinational block decodes the state into the three lamp outputs.

## Limitations / next improvements

- This is a basic single-road FSM, not a complete intersection controller.
- No pedestrian button, emergency mode, vehicle sensor, or fault handling is included.
- No hardware board or physical lamp interface is demonstrated.
- For a more advanced version, add pedestrian requests, a second road, and safety interlocks with additional test cases.

## Academic note

This project is a **Verilog RTL simulation project**. Simulation validates the modeled logic; it does not by itself prove FPGA deployment or real-world safety.
