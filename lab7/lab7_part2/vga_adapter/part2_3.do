vlib work
vlog -timescale 1ns/1ns part2.v
vsim part2

log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 2 -r 4 

# reset_n, flipped signal in code
force {KEY[0]} 0
# go
force {KEY[1]} 1

force {SW[9]} 1
force {SW[8]} 0
force {SW[7]} 1

run 4ns

# reset off
force {KEY[0]} 1

run 4ns

force {KEY[3]} 1

# load x
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0

run 4ns

force {KEY[3]} 0

# load y
force {SW[6]} 1 
force {SW[5]} 1
force {SW[4]} 0
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0

run 4ns

# press button == 0 --> go b/c we flipped
force {KEY[1]} 0

run 4ns

# unpress the button
force {KEY[1]} 1

run 40ns
