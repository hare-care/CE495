module cordic_stage
#(
    parameter dwidth = 14,
    parameter index = 0,
    parameter quant = 16
) (
    input   logic        clk,
    input   logic        reset,
    input   logic [15:0] x_in,
    input   logic [15:0] y_in,
    input   logic [15:0] z_in,
    input   logic        valid_in,
    output  logic [15:0] x_out,
    output  logic [15:0] y_out,
    output  logic [15:0] z_out,
    output  logic        valid_out
);


parameter cordic_table = {16'h3243, 16'h1DAC, 16'h0FAD, 16'h07F5,
                          16'h03FE, 16'h01FF, 16'h00FF, 16'h007F,
                          16'h003F, 16'h001F, 16'h000F, 16'h0007, 
                          16'h0003, 16'h0001, 16'h0000, 16'h0000};

logic [15:0] x, x_c, y, y_c, z, z_c;
logic valid_c;
logic d;


always_comb 
begin
    x_c <= '0;
    y_c <= '0;
    z_c <= '0;
    valid_c <= '0;
    
    if (valid_in == 1'b1)
    begin
        if (z_in[dwidth-1] == 1) begin
            d <= 1'b1;
        end
        else begin
            d <= 1'b0;
        end
        x_c <= x_in - (((y_in >> index)^ d)-d);
        y_c <= y_in + (((x_in >> index)^ d)-d);
        z_c <= z_in - ((cordic_table[index] ^ d)- d);
    end



end

always_ff
begin
    if (reset == 1'b1) begin
        x_out <= '0;
        y_out <= '0;
        z_out <= '0;
        valid_out <= '0;
    end else begin
        x_out <= x_c;
        y_out <= y_c;
        z_out <= z_c;
        valid_out <= valid_c;
        
    end

end




endmodule