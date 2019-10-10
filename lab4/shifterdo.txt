vlib work
vlog -timescale 1ns/1ns shifter.v
vsim shifter

log {/*}
add wave {/*}

#reset_n
force {SW[9]} 1
#clk
force {KEY[0]} 0 0, 1 20 -r 40
#load n
force {KEY[1]} 1
#shift
force {KEY[2]} 1
#asr
force {KEY[3]} 0
#load val
force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

run 40ns

#reset_n
force {SW[9]} 1
#clk
force {KEY[0]} 0 0, 1 20 -r 40
#load n
force {KEY[1]} 1
#shift
force {KEY[2]} 1
#asr
force {KEY[3]} 1
#load val
force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

run 40ns

# case q 1
#reset_n
force {SW[9]} 1
#clk
force {KEY[0]} 0 0, 1 20 -r 40
#load n
force {KEY[1]} 1
#shift
force {KEY[2]} 0
#asr
force {KEY[3]} 0
#load val
force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

run 40ns

#reset_n
force {SW[9]} 1
#clk
force {KEY[0]} 0 0, 1 20 -r 40
#load n
force {KEY[1]} 1
#shift
force {KEY[2]} 0
#asr
force {KEY[3]} 0
#load val
force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1

run 40ns

# LEDR = q
# SW[9] = reset_n;
force {SW[9]} 0 0, 1 5, 0 100, 1 105
# SW[7:0] = LoadVal[7:0];
force {SW[7: 0]} 10101010 0, 10101010 100
# KEY[0] = clk;
force {KEY[0]} 0 0, 1 5 -r 10
# KEY[1] = Load_n;
force {KEY[1]} 0 10, 1 20, 0 110, 1 120
# KEY[2] = ShiftRight;
force {KEY[2]} 0 0, 1 20 -r 100
# KEY[3] = ASR
force {KEY[3]} 0 0, 1 100 -r 200
run 180ns
