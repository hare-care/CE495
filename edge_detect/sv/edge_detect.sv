
module edge_detect #(
    parameter WIDTH = 720,
    parameter HEIGHT= 540,
    parameter DATA_WIDTH = 24,
    parameter FIFO_BUFFER_SIZE = 32)
(
    input  logic clock,
    input  logic reset,
    output logic input_full,
    input  logic input_wr_en,
    input  logic [DATA_WIDTH-1:0] input_din,
    input  logic out_rd_en,
    output logic out_empty,
    output logic [DATA_WIDTH /3 -1:0] out_dout
);

logic [DATA_WIDTH-1:0] input_dout;
logic [DATA_WIDTH/3 -1 :0] gs_din, gs_dout, out_din;
logic input_empty, input_rd_en, gs_full, gs_wr_en, gs_empty, gs_rd_en;

grayscale #(
) grayscale_inst (
    .clock(clock),
    .reset(reset),
    .in_dout(input_dout),
    .in_rd_en(input_rd_en),
    .in_empty(input_empty),
    .out_din(gs_din),
    .out_full(gs_full),
    .out_wr_en(gs_wr_en)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) gs_fifo (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(gs_wr_en),
    .din(gs_din),
    .full(gs_full),
    .rd_clk(clock),
    .rd_en(gs_rd_en),
    .dout(gs_dout),
    .empty(gs_empty)
);




fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) input_fifo (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(input_wr_en),
    .din(input_din),
    .full(input_full),
    .rd_clk(clock),
    .rd_en(input_rd_en),
    .dout(input_dout),
    .empty(input_empty)
);

sobel #(
) sobel_inst (
     .clock(clock),
    .reset(reset),
    .in_dout(gs_dout),
    .in_rd_en(gs_rd_en),
    .in_empty(gs_empty),
    .out_din(out_din),
    .out_full(out_full),
    .out_wr_en(out_wr_en)
);


fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH/3)
) output_fifo (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(out_wr_en),
    .din(out_din),
    .full(out_full),
    .rd_clk(clock),
    .rd_en(out_rd_en),
    .dout(out_dout),
    .empty(out_empty)
);

endmodule