vlib work

vlog -timescale 1ns/1ns mux.v

vsim mux

log {/*}
add wave {/*}

force {SW[0]} 0 0, 1 10 -r 20
force {SW[1]} 0 0, 1 10 -r 40
force {SW[2]} 0 0, 1 10 -r 80
force {SW[3]} 0 0, 1 10 -r 160
force {SW[4]} 0 0, 1 10 -r 320
force {SW[5]} 0 0, 1 10 -r 640
force {SW[6]} 0 0, 1 10 -r 1280
force {SW[7]} 0 0, 1 10 -r 2560
force {SW[8]} 0 0, 1 10 -r 5120
force {SW[9]} 0 0, 1 10 -r 20

run 10240

