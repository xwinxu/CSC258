vlib work
vlog -timescale 1ns/1ns m3.v
vsim m3

log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 1 -r 2

force {KEY[1]} 1
force {KEY[0]} 0
force {SW} 1001
run 2ns

force {KEY[0]} 1
run 2ns

# load A
force {KEY[1]} 0
run 2ns

force {KEY[1]} 1
run 1000ns

# load B
force {SW} 0100
force {KEY[1]} 0
run 2ns

force {KEY[1]} 1
run 1000ns

# load op
force {SW} 0011
force {KEY[1]} 0
run 2ns

force {KEY[1]} 1
run 3000ns
