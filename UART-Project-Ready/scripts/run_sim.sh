#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
for tool in iverilog vvp; do
  command -v "$tool" >/dev/null || { echo "Missing $tool. Install Icarus Verilog first."; exit 1; }
done
mkdir -p sim

run_test() {
  local name="$1"; shift
  echo "=== $name ==="
  iverilog -g2012 -Wall -o "sim/${name}_run" "$@"
  vvp "sim/${name}_run"
}
run_test uart_tx src/uart_tx.v tb/tb_uart_tx.v
run_test uart_rx src/uart_rx.v tb/tb_uart_rx.v
run_test uart_loopback src/uart_tx.v src/uart_rx.v tb/tb_uart_loopback.v | tee sim/loopback.log
grep -q "ALL TESTS PASSED" sim/loopback.log || { echo "Loopback check did not pass."; exit 1; }
echo "Simulation suite completed."
