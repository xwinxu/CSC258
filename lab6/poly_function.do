vlib work
vlog -timescale 1ns/1ns fpga_top.v
vsim fpga_top

log {/*}
add wave {/*}


# clk signal
force {CLOCK_50} 0 0, 1 2 -r 4

# reset
force {KEY[0]} 0

run 8ns

# turn reset off
force {KEY[0]} 1
run 4ns

# go
force {KEY[1]} 0

# load in A
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

run 10ns

# go signal
force {KEY[1]} 1

run 10ns


# go
force {KEY[1]} 0

# load in B
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

run 10ns

# go signal
force {KEY[1]} 1

run 10ns

# go
force {KEY[1]} 0

# load in C
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

run 10ns

# go signal
force {KEY[1]} 1

run 10ns

# go
force {KEY[1]} 0

# load in X
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

run 10ns

# go signal
force {KEY[1]} 1

run 24ns

