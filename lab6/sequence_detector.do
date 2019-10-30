vlib work
vlog -timescale 1ns/1ns sequence_detector.v
vsim sequence_detector

log {/*}
add wave {/*}


# clk signal, start at 1 then go to 0
force {KEY[0]} 1 0, 0 10 -r 20

# run 200ns

# reset signal
force {SW[0]} 0

run 20ns

# turn signal off, active low
force {SW[0]} 1

# specify w
force {SW[1]} 0

run 40ns

force {SW[1]} 1
run 100ns

force {SW[1]} 0 
run 20ns

force {SW[1]} 1
run 20ns

force {SW[1]} 0
run 60ns
