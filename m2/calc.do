vlib work
vlog -timescale 1ns/1ns m2.v
vsim calc

log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2

force {go} 0
force {resetn} 0
run 2ns

force {resetn} 1
run 2ns

# load A (10)
force {go} 1
force {data_in} 1010
run 2ns

force {go} 0
run 2ns

# load B (3)
force {go} 1
force {data_in} 0011
run 2ns

force {go} 0
run 2ns

# load op
force {go} 1
force {data_in} 0011
run 2ns

force {go} 0
run 80ns

force {go} 0
force {resetn} 0
run 2ns

force {resetn} 1
run 2ns

# load A (10)
force {go} 1
force {data_in} 1010
run 2ns

force {go} 0
run 2ns

# load B (3)
force {go} 1
force {data_in} 0011
run 2ns

force {go} 0
run 2ns

# load op
force {go} 1
force {data_in} 0000
run 2ns

force {go} 0
run 80ns
