vlib work
vlog -timescale 1ns/1ns ram32x4.v
vsim -L altera_mf_ver ram32x4

log {/*}
add wave {/*}

# clk signal
# Note: specify ns b/c -L above makes it zoomed in and clock cycle off (should be ps)
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

# address (read from another place, expect 0 b/c unset)
force {address[0]} 1
force {address[1]} 1 
force {address[2]} 0
force {address[3]} 0
force {address[4]} 0

# leave the write the same as before

# writeEn
force {wren} 0

run 4ns


# address read from the original place (expect 1)
force {address[0]} 1
force {address[1]} 0 
force {address[2]} 0
force {address[3]} 0
force {address[4]} 0

# writeEn
force {wren} 0

run 4ns

