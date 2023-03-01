module cordic_top
# (
    parameter RAD_WIDTH = 32,
    parameter DATA_WIDTH = 16,
    parameter FIFO_BUFFER_SIZE = 32
) (
    input logic clk,
    input logic reset,
    input logic rad_wr_en,
    input logic [31:0] rad_in,
    input logic sin_rd_en,
    input logic cos_rd_en,
    output logic [15:0] sin_dout,
    output logic [15:0] cos_dout,
    output logic sin_empty,
    output logic cos_empty,
    output logic rad_full
);

logic rad_rd_en, rad_empty;
logic [31:0] rad_dout;

logic sin_full, cos_full, sin_wr_en, cos_wr_en;
logic [15:0] sin_in, cos_in;




fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(RAD_WIDTH)
) rad_fifo_inst (
    .reset(reset),
    .wr_clk(clk),
    .wr_en(rad_wr_en),
    .din(rad_in),
    .full(rad_full),
    .rd_clk(clk),
    .rd_en(rad_rd_en),
    .dout(rad_dout),
    .empty(rad_empty)
);

assign valid_in = rad_rd_en;
assign sin_wr_en = cos_wr_en;
assign cos_wr_en = valid_out & ~sin_full & ~cos_full;

cordic #(

) cordic_inst (
    .clk(clk),
    .reset(reset),
    .radian(rad_dout),
    .valid_in(valid_in),
    .sin(sin_in),
    .cos(cos_in),
    .valid_out(valid_out)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
)sin_fifo_inst (
    .reset(reset),
    .wr_clk(clk),
    .wr_en(sin_wr_en),
    .din(sin_in),
    .full(sin_full),
    .rd_clk(clk),
    .rd_en(sin_rd_en),
    .dout(sin_dout),
    .empty(sin_empty)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) cos_fifo_inst (
    .reset(reset),
    .wr_clk(clk),
    .wr_en(cos_wr_en),
    .din(cos_in),
    .full(cos_full),
    .rd_clk(clk),
    .rd_en(cos_rd_en),
    .dout(cos_dout),
    .empty(cos_empty)
);


endmodule