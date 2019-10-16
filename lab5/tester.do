vlib work
vlog -timescale 1ns/1ns testflip.v
vsim tflipf

log {/*}
add wave {/*}


#clk
force {clk[0]} 0
# enable
force {t[0]} 0
# clearb
force {clr[0]} 0

run 20ns

#clk
force {clk[0]} 0 0, 1 10 -r 20

# clearb (active low)
force {clr[0]} 1

run 5ns

# enable
force {t[0]} 1

run 5ns

# enable
force {t[0]} 0

run 20ns

# enable
force {t[0]} 1

run 20ns

# enable
force {t[0]} 0
run 10ns

# enable
force {t[0]} 1
run 10ns

# enable
force {t[0]} 0
run 5ns


# run 120ns
