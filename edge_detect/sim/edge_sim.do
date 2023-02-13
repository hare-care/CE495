
setenv LMC_TIMEUNIT -9
vlib work
vmap work work

vlog -work work "../sv/fifo.sv"
vlog -work work "../sv/grayscale.sv"
vlog -work work "../sv/sobel.sv"
vlog -work work "../sv/edge_detect.sv"
vlog -work work "../sv/edge_detect_tb.sv"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.edge_detect_tb -wlf edge_detect.wlf

do edge_wave.do

run -all

