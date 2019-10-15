vlib work
vlog -timescale 1ns/1ns counter.v
vsim counter

log {/*}
add wave {/*}


#clk
force {KEY[0]} 0
# enable
force {SW[1]} 0
# clearb
force {SW[0]} 0

run 40ns

#clk
force {KEY[0]} 0 0, 1 1 -r 2
# enable
force {SW[1]} 1
# clearb (active low)
force {SW[0]} 1

run 40ns

