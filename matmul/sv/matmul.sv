module matmul
#(  parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,
    parameter MATRIX_SIZE = 1024)
(
    input logic                      clock,
    input logic                      reset,
    input logic                      start,
    input logic                      done,
    input logic     [DATA_WIDTH-1:0] x_dout,
    input logic     [DATA_WIDTH-1:0] y_dout,
    output logic    [ADDR_WIDTH-1:0] x_addr,
    output logic    [ADDR_WIDTH-1:0] y_addr,
    output logic    [ADDR_WIDTH-1:0] z_addr,
    output logic    [DATA_WIDTH-1:0] z_din,
    output logic                     z_wr_en
);