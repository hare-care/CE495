add wave -noupdate -group matmul_tb
add wave -noupdate -group matmul_tb -radix hexadecimal /matmul_tb/*

add wave -noupdate -group matmul_tb/matmul_top_inst
add wave -noupdate -group matmul_tb/matmul_top_inst -radix hexadecimal /matmul_tb/matmul_top_inst/*

add wave -noupdate -group matmul_tb/matmul_top_inst/matmul_inst
add wave -noupdate -group matmul_tb/matmul_top_inst/matmul_inst -radix hexadecimal /matmul_tb/matmul_top_inst/matmul_inst/*

add wave -noupdate -group matmul_tb/matmul_top_inst/x_inst
add wave -noupdate -group matmul_tb/matmul_top_inst/x_inst -radix hexadecimal /matmul_tb/matmul_top_inst/x_inst/*

add wave -noupdate -group matmul_tb/matmul_top_inst/y_inst
add wave -noupdate -group matmul_tb/matmul_top_inst/y_inst -radix hexadecimal /matmul_tb/matmul_top_inst/y_inst/*

add wave -noupdate -group matmul_tb/matmul_top_inst/z_inst
add wave -noupdate -group matmul_tb/matmul_top_inst/z_inst -radix hexadecimal /matmul_tb/matmul_top_inst/z_inst/*
