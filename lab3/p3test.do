vlib work

vlog -timescale 1ns/1ns alu.v

vsim alu

log {/*}
add wave {/*}

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0

force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 0

run 10ns

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns       

force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 0
force {SW[4]} 0
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 0
force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 0
run 10ns       

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 1
force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 0
run 10ns       

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns       

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 0
force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns       

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns       

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns       

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns       

