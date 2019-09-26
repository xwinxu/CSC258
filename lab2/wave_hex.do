# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns hex.v

# Load simulation using mux as the top level simulation module.
vsim hex

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Assuming 0 is the units, 1 is the tenths, etc

# B
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[0]} 1
force {SW[1]} 1
force {SW[3]} 0
force {SW[4]} 1

run 10ns

# A
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[0]} 0
force {SW[1]} 1
force {SW[3]} 0
force {SW[4]} 1

run 10ns

# 3
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[0]} 1
force {SW[1]} 1
force {SW[3]} 0
force {SW[4]} 0

run 10ns

# 1
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[0]} 1
force {SW[1]} 0
force {SW[3]} 0
force {SW[4]} 0

run 10ns

# 4
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[0]} 0
force {SW[1]} 0
force {SW[3]} 1
force {SW[4]} 0

run 10ns

# 5
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[0]} 1
force {SW[1]} 0
force {SW[3]} 1
force {SW[4]} 0

run 10ns
