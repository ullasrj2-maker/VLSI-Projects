$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Get-Command iverilog -ErrorAction SilentlyContinue)) { throw 'iverilog is missing. Install Icarus Verilog and add it to PATH.' }
if (-not (Get-Command vvp -ErrorAction SilentlyContinue)) { throw 'vvp is missing. Install Icarus Verilog and add it to PATH.' }
New-Item -ItemType Directory -Force sim | Out-Null

Write-Host '=== UART TX test ==='
iverilog -g2012 -Wall -o sim/uart_tx_run src/uart_tx.v tb/tb_uart_tx.v
if ($LASTEXITCODE -ne 0) { throw 'TX compile failed' }
vvp sim/uart_tx_run
if ($LASTEXITCODE -ne 0) { throw 'TX simulation failed' }

Write-Host '=== UART RX test ==='
iverilog -g2012 -Wall -o sim/uart_rx_run src/uart_rx.v tb/tb_uart_rx.v
if ($LASTEXITCODE -ne 0) { throw 'RX compile failed' }
vvp sim/uart_rx_run
if ($LASTEXITCODE -ne 0) { throw 'RX simulation failed' }

Write-Host '=== UART loopback test ==='
iverilog -g2012 -Wall -o sim/uart_loopback_run src/uart_tx.v src/uart_rx.v tb/tb_uart_loopback.v
if ($LASTEXITCODE -ne 0) { throw 'Loopback compile failed' }
$output = vvp sim/uart_loopback_run
$output | Tee-Object sim/loopback.log
if ($LASTEXITCODE -ne 0 -or $output -notcontains 'ALL TESTS PASSED') { throw 'Loopback test did not pass' }
Write-Host 'Simulation suite completed.'
