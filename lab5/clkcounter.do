vlib work
vlog -timescale 1ns/1ns clkcounter.v
vsim clkcounter

log {/*}
add wave {/*}


#clk
force {CLOCK_50} 0 0, 1 1 -r 2
# reset_n counter
force {SW[3]} 0
# reset_n rate divider
force {SW[2]} 0
# rate bit 1
force {SW[1]} 0
# rate bit 0
force {SW[0]} 0

run 2ns

# reset_n counter
force {SW[3]} 1
# reset_n rate divider
force {SW[2]} 1
# rate bit 1
force {SW[1]} 1
# rate bit 0
force {SW[0]} 1

run 120ns


#clk
force {CLOCK_50} 0 0, 1 1 -r 2
# reset_n counter
force {SW[3]} 0
# reset_n rate divider
force {SW[2]} 0
# rate bit 1
force {SW[1]} 0
# rate bit 0
force {SW[0]} 0

run 2ns

# reset_n counter
force {SW[3]} 1
# reset_n rate divider
force {SW[2]} 1
# rate bit 1
force {SW[1]} 0
# rate bit 0
force {SW[0]} 1

run 120ns