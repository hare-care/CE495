module cordic 
#(
    parameter dwidth = 14,
    parameter index = 0,
    parameter quant = 16
) (
    input   logic        clk,
    input   logic        reset,
    input   logic [31:0] radian,
    input   logic        valid_in,
    output  logic [15:0] sin,
    output  logic [15:0] cos,
    output  logic        valid_out
);
paramter R_PI  = 3.14159265358979323846;
function [15:0] quant (input real r);
    quant = r*(2**4);
endfunction
parameter HALF_PI = quant(R_PI/2);
parameter PI = quant(R_PI);
parameter CORDIC_1K = quant(1/1.646760258121066);

always_comb begin
x_temp = 
if (radian > HALF_PI) begin
    radian = radian - PI;
    x_temp[0] = -x_temp[0];
end
else if (radian < -HALF_PI) begin
    radian = radian +PI;
    x_temp[0] = -x_temp[0];
end
end

assign y_temp[0] = '0;
assign z_temp[0] = radian;

logic [16:0] x_temp [15:0];
logic [16:0] y_temp [15:0];
logic [16:0] z_temp [15:0];
logic [16:0] valid_temp;

assign sin = y_temp[16];
assign cos = x_temp[16];
assign valid_out = valid_temp[16];

genvar i;
generate 
    for (i=0; i < 16; i++) begin

        cordic_stage #(
            index = i;
        ) (
            .clk(clk),
            .reset(reset),
            .x_in(x_temp[i]),
            .y_in(y_temp[i]),
            .z_in(z_temp[i]),
            .valid_in(valid_temp[i]),
            .x_out(x_temp[i+1]),
            .y_out(y_temp[i+1]),
            .z_out(z_temp[i+1]),
            .valid_out(valid_temp[i+1])
        );
    end
endgenerate


endmodule