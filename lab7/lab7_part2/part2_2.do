vlib work
vlog -timescale 1ns/1ns part2.v
vsim control

log {/*}
add wave {/*}

force {clk} 0 0, 1 2 -r 4

force {resetn} 0

force {go} 0

run 4ns

force {resetn} 1

# S_W_WAIT
force {go} 1

run 4ns

# S_CYCLE_0
force {go} 0

run 40ns
