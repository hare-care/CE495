
module edge_detect_top #(  
    parameter DATA_WIDTH = 24,
    parameter FIFO_BUFFER_SIZE = 32)
(
    input  logic clock,
    input  logic reset,
    output logic input_full,
    input  logic input_wr_en,
    input  logic [DATA_WIDTH-1:0] input_din,
    output logic in_hold_full,
    input  logic in_hold_wr_en,
    input  logic [DATA_WIDTH-1:0] in_hold_din,
    output logic base_full,
    input  logic base_wr_en,
    input  logic [DATA_WIDTH-1:0] base_din,
    input  logic z_rd_en,
    output logic z_empty,
    output logic [DATA_WIDTH-1:0] z_dout
);

logic [DATA_WIDTH-1:0] input_dout, x_dout, y_dout, z_din, base_dout, in_hold_dout, mask_dout, mask_din;
logic [DATA_WIDTH/3 -1:0] x_din, y_din;
logic input_empty, in_full, x_empty, y_full, y_empty, z_full, mask_full, mask_empty;
logic input_rd_en, x_wr_en, x_rd_en, y_wr_en, y_rd_en, z_wr_en, mask_rd_en, mask_wr_en;

grayscale #(
) grayscale_inst (
    .clock(clock),
    .reset(reset),
    .in_dout(base_dout),
    .in_rd_en(base_rd_en),
    .in_empty(base_empty),
    .out_din(y_din),
    .out_full(y_full),
    .out_wr_en(y_wr_en)
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



);



fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) output_fifo (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(),
    .din(),
    .full(),
    .rd_clk(clock),
    .rd_en(),
    .dout(),
    .empty()
);
















endmodule