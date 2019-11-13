vlib work
vlog -timescale 1ns/1ns ram32x4.v
vsim -L altera_mf_ver ram32x4

log {/*}
add wave {/*}

# clk signal
force {clock} 0 0ns, 1 2ns -r 4ns

# address (hold a 5 bit value)
force {address[0]} 1
force {address[1]} 0
force {address[2]} 0
force {address[3]} 0
force {address[4]} 0

# data (to write to address)
force {data[0]} 1
force {data[1]} 0
force {data[2]} 0
force {data[3]} 0

# writeEn
force {wren} 1

run 4ns



