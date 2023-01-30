
module motion_detect_top #(  
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
) base_grayscale_inst (
    .clock(clock),
    .reset(reset),
    .in_dout(base_dout),
    .in_rd_en(base_rd_en),
    .in_empty(base_empty),
    .out_din(y_din),
    .out_full(y_full),
    .out_wr_en(y_wr_en)
);

grayscale #(
) input_grayscale_inst (
    .clock(clock),
    .reset(reset),
    .in_dout(input_dout),
    .in_rd_en(input_rd_en),
    .in_empty(input_empty),
    .out_din(x_din),
    .out_full(x_full),
    .out_wr_en(x_wr_en)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) input_inst (
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

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) base_inst (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(input_wr_en),
    .din(base_din),
    .full(base_full),
    .rd_clk(clock),
    .rd_en(base_rd_en),
    .dout(base_dout),
    .empty(base_empty)
);

vectorsub #(
  .DATA_WIDTH(DATA_WIDTH)
) vectorsub_inst (
    .clock(clock),
    .reset(reset),
    .x_dout(x_dout),
    .x_rd_en(x_rd_en),
    .x_empty(x_empty),
    .y_dout(y_dout),
    .y_rd_en(y_rd_en),
    .y_empty(y_empty),
    .z_din(mask_din),
    .z_full(mask_full),
    .z_wr_en(mask_wr_en)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) x_inst (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(x_wr_en),
    .din(x_din),
    .full(x_full),
    .rd_clk(clock),
    .rd_en(x_rd_en),
    .dout(x_dout),
    .empty(x_empty)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) y_inst (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(y_wr_en),
    .din(y_din),
    .full(y_full),
    .rd_clk(clock),
    .rd_en(y_rd_en),
    .dout(y_dout),
    .empty(y_empty)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) mask_inst (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(mask_wr_en),
    .din(mask_din),
    .full(mask_full),
    .rd_clk(clock),
    .rd_en(mask_rd_en),
    .dout(mask_dout),
    .empty(mask_empty)
);

motion_detect #(
    .DATA_WIDTH(DATA_WIDTH)
) motion_detect_inst (
    .reset(reset),
    .clock(clock),
    .mask_dout(mask_dout),
    .mask_empty(mask_empty),
    .mask_rd_en(mask_rd_en),
    .base_dout(in_hold_dout),
    .base_empty(in_hold_empty),
    .base_rd_en(in_hold_rd_en),
    .z_din(z_din),
    .z_full(z_full),
    .z_wr_en(z_wr_en)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) z_inst (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(z_wr_en),
    .din(z_din),
    .full(z_full),
    .rd_clk(clock),
    .rd_en(z_rd_en),
    .dout(z_dout),
    .empty(z_empty)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(DATA_WIDTH)
) in_hold_inst (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(in_hold_wr_en),
    .din(in_hold_din),
    .full(in_hold_full),
    .rd_clk(clock),
    .rd_en(in_hold_rd_en),
    .dout(in_hold_dout),
    .empty(in_hold_empty)
);





endmodule