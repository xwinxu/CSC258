vlib work
vlog -timescale 1ns/1ns morse.v
vsim morse

log {/*}
add wave {/*}


force {CLOCK_50} 0 0 ns, 1 1 ns -r 2
force {KEY[0]} 0 0 ns, 1 4 ns -r 104
force {KEY[1]} 0 0 ns, 1 8 ns -r 108
force {SW[2:0]} 010 
run 100 ns

force {SW[2:0]} 001
run 100 ns

force {SW[2:0]} 000
run 100ns

force {SW[2:0]} 011
run 100ns

force {SW[2:0]} 100
run 100ns

force {SW[2:0]} 101
run 100ns

force {SW[2:0]} 110
run 100ns

force {SW[2:0]} 111
run 100ns