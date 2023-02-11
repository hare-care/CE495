

#add wave -noupdate -group my_uvm_tb
#add wave -noupdate -group my_uvm_tb -radix hexadecimal /my_uvm_tb/*

add wave -noupdate -group my_uvm_tb/edge_detect_inst
add wave -noupdate -group my_uvm_tb/edge_detect_inst -radix hexadecimal /my_uvm_tb/edge_detect_inst/*

add wave -noupdate -group my_uvm_tb/edge_detect_inst/grayscale_inst
add wave -noupdate -group my_uvm_tb/edge_detect_inst/grayscale_inst -radix hexadecimal /my_uvm_tb/edge_detect_inst/grayscale_inst/*

add wave -noupdate -group my_uvm_tb/edge_detect_inst/sobel_inst
add wave -noupdate -group my_uvm_tb/edge_detect_inst/sobel_inst -radix hexadecimal /my_uvm_tb/edge_detect_inst/sobel_inst/*

add wave -noupdate -group my_uvm_tb/edge_detect_inst/input_fifo
add wave -noupdate -group my_uvm_tb/edge_detect_inst/input_fifo -radix hexadecimal /my_uvm_tb/edge_detect_inst/input_fifo/*

add wave -noupdate -group my_uvm_tb/edge_detect_inst/gs_fifo
add wave -noupdate -group my_uvm_tb/edge_detect_inst/gs_fifo -radix hexadecimal /my_uvm_tb/edge_detect_inst/gs_fifo/*

add wave -noupdate -group my_uvm_tb/edge_detect_inst/output_fifo
add wave -noupdate -group my_uvm_tb/edge_detect_inst/output_fifo -radix hexadecimal /my_uvm_tb/edge_detect_inst/output_fifo/*

