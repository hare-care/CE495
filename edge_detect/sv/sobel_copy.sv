module sobel #(
    WIDTH = 720,
    HEIGHT= 540
)
(
    input  logic        clock,
    input  logic        reset,
    output logic        in_rd_en,
    input  logic        in_empty,
    input  logic [7:0]  in_dout,
    output logic        out_wr_en,
    input  logic        out_full,
    output logic [7:0]  out_din

);

logic [10:0] h_grad, v_grad;
logic x,y, x_c, y_c;
logic [9:0] cnt, cnt_c;

logic [10:0] out_hold;
logic [7:0] out_din_temp;

logic [7:0] buffer [2:0][2:0];

logic [7:0][1443-1:0]shift_reg;
logic [7:0][1443-1:0] shift_reg_c;
typedef enum logic [1:0] {s0, s1, s2} state_types;
state_types state, state_c;

parameter h_op = {{8'hFF, 8'h00, 8'h01}, 
                  {8'hFE, 8'h00, 8'h02},
                  {8'hFF, 8'h00, 8'h01}};
parameter v_op = {{8'hFF, 8'hFE, 8'hFF}, 
                  {8'h00, 8'h00, 8'h00},
                  {8'h01, 8'h02, 8'h01}};

function [15:0] abs (input logic [15:0] val);
    abs = (val[15])? -val:val;
endfunction;

always_ff @(posedge clock or posedge reset) begin
    if (reset == 1'b1) begin
        state <= s0;
        y = '0;
        x = '0;
        cnt = '0;
        shift_reg = '0;

        
    end else begin
        state <= state_c;
        x = x_c;
        y = y_c;
        cnt = cnt_c;
        shift_reg = shift_reg_c;
        
    end
end

always_comb
begin
    in_rd_en  = 1'b0;
    out_wr_en = 1'b0;
    out_din   = 8'b0;
    state_c   = state;
    cnt_c = cnt;
    shift_reg_c = shift_reg;

    for (int j = 0; j < 3; j++) begin
        for (int i = 0; i < 3; i++) begin
            h_grad = h_grad + 1*$signed(h_op[i][j]);
            v_grad = v_grad + 1*$signed(v_op[i][j]);
        end
    end

    out_hold = abs(v_grad) + abs(h_grad);
    out_din_temp = ($unsigned(out_hold) > 255)  ? 8'hFF  : out_hold[7:0];






    case (state)
        s0: begin
            x_c = '0;
            y_c = '0;
            state_c = s1;
        end
        s1: begin
            if ($unsigned(cnt)<1443) begin
                if (in_empty == 1'b0) begin
                in_rd_en = 1'b1;
                shift_reg_c[1442:1] = shift_reg[1443-2:0];
                shift_reg_c[0] = in_dout;
                cnt_c = cnt +1;
                state_c = s1;
                end
            end
            else state_c = s2;

        end
        s2: begin
            if (in_empty == 1'b0) begin
                in_rd_en = 1'b1;
                shift_reg_c[1442:1] = shift_reg[1443-2:0];
                shift_reg_c[0] = in_dout;
            end
            if (out_full == 1'b0)
            begin
                out_din = $unsigned(shift_reg[1443-1][7:0]) + $unsigned(shift_reg[1443-2][7:0]);
                out_wr_en = 1'b1;
                x_c = $unsigned(x) + 1;
                if ($unsigned(x_c)>WIDTH) begin
                    x_c = '0;
                    y_c = $unsigned(y)+1;
                    if ($unsigned(y_c) > HEIGHT) begin
                        y_c = '0;
                    end
                end
                if ( ($unisgned(y) != 0) & ($unsigned(x) != 0) & ($unsigned(y) != HEIGHT-1 ) & ($unsigned(x) != WIDTH-1)) begin
                end

            end


        end
    endcase


end

endmodule




module shift_register
#(
    parameter IMG_WIDTH = 720,
    parameter WIDTH = 8
) (
    input logic clock,
    input logic reset,
    input logic [WIDTH-1:0] d_in,
    output logic [WIDTH-1:0] data_1,
    output logic [WIDTH-1:0] data_2,
    output logic [WIDTH-1:0] data_3,
    output logic [WIDTH-1:0] data_4,
    output logic [WIDTH-1:0] data_5,
    output logic [WIDTH-1:0] data_6,
    output logic [WIDTH-1:0] data_7,
    output logic [WIDTH-1:0] data_8,
    output logic [WIDTH-1:0] data_9
);
    parameter LENGTH = IMG_WIDTH*2+3;

    logic [WIDTH-1:0] [LENGTH-1:0]shift_reg;

    assign data_1 = shift_reg[LENGTH-1];
    assign data_2 = shift_reg[LENGTH-2];
    assign data_3 = shift_reg[LENGTH-3];
    assign data_4 = shift_reg[IMG_WIDTH+3-1];
    assign data_5 = shift_reg[IMG_WIDTH+3-2];
    assign data_6 = shift_reg[IMG_WIDTH+3-3];
    assign data_7 = shift_reg[2];
    assign data_8 = shift_reg[1];
    assign data_9 = shift_reg[0];

    always_ff @(posedge clock, posedge reset) 
    begin
    if (reset == 1'b1) begin
        shift_reg <= '0;
    end else begin
        shift_reg[LENGTH-1:1] <= shift_reg[LENGTH-2:0];
        shift_reg[0] <= d_in;
    end

    end




endmodule