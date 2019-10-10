vlib work

vlog -timescale 1ns/1ns regalu.v

vsim regalu

log {/*}
add wave {/*}

// clock (5 secs 0, 5 secs 1)
force {KEY[0]} 0 0, 1 5 -r 10
force {SW[9]} 1

// A+1
// Function inputs of alu
force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0

// reset_n
//force {SW[9]} 0
// data (set A only, B is register)
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// reset_n
//force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// A+B
// Function inputs
force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1
// reset_n
//force {SW[9]} 0
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// A+B using verilog
// Function inputs
force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 0
// reset_n
//force {SW[9]} 0
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// reset_n
//force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// A XOR B in lower 4 bits, A OR B in higher 4
// Function inputs
force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 1
// reset_n
//force {SW[9]} 0
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// reset_n
//force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// A and B reduction OR
// Function inputs
force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 0
// reset_n
//force {SW[9]} 0
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// reset_n
//force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// Left shift B by A bits
// Function inputs
force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 1
// reset_n
force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// reset_n
force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// Right shift B by A bits
// Function inputs
force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 0
// reset_n
force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// reset_n
force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// A X B using Verilog *
// Function inputs
force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
// reset_n
force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

// reset_n
force {SW[9]} 1
// data
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
run 10ns
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns