vlib work
vlog -timescale 1ns/1ns part2.v
vsim datapath

log {/*}
add wave {/*}

force {clk} 0 0, 1 2 -r 4

force {color[0]} 1
force {color[1]} 0
force {color[2]} 0

force {resetn} 0

force {ctrl[0]} 0
force {ctrl[1]} 1
force {ctrl[2]} 1 
force {ctrl[3]} 0

run 4ns

force {resetn} 1

force {loadx} 1

force {data_in[0]} 0
force {data_in[1]} 1
force {data_in[2]} 0
force {data_in[3]} 0
force {data_in[4]} 1
force {data_in[5]} 0
force {data_in[6]} 0

run 4ns

force {loadx} 0

force {data_in[0]} 1
force {data_in[1]} 1
force {data_in[2]} 0
force {data_in[3]} 0
force {data_in[4]} 1
force {data_in[5]} 0
force {data_in[6]} 0

run 4ns