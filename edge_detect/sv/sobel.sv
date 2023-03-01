module sobel #(
    WIDTH = 720,
    HEIGHT = 540
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
logic [9:0] x,y, x_c, y_c;
logic [10:0] cnt, cnt_c;

logic [10:0] out_hold;
logic [7:0] out_din_temp;

logic [2:0][2:0][7:0] buffer;

typedef enum logic [1:0] {s0, s1, s2} state_types;
state_types state, state_c;

parameter [7:0] h_op [2:0][2:0]= '{'{8'hFF, 8'h00, 8'h01}, 
                                   '{8'hFE, 8'h00, 8'h02},
                                   '{8'hFF, 8'h00, 8'h01}};
parameter [7:0] v_op [2:0][2:0]= '{'{8'hFF, 8'hFE, 8'hFF}, 
                                   '{8'h00, 8'h00, 8'h00},
                                   '{8'h01, 8'h02, 8'h01}};

function [15:0] abs (input logic [15:0] val);
    abs = (val[15])? -val:val;
endfunction;

shift_register #() shift_reg_inst (
    .clock(clock),
    .reset(reset),
    .enable(in_rd_en),
    .d_in(in_dout),
    .data_1(buffer[0][0]),
    .data_2(buffer[0][1]),
    .data_3(buffer[0][2]),
    .data_4(buffer[1][0]),
    .data_5(buffer[1][1]),
    .data_6(buffer[1][2]),
    .data_7(buffer[2][0]),
    .data_8(buffer[2][1]),
    .data_9(buffer[2][2])
);





always_ff @(posedge clock or posedge reset) begin
    if (reset == 1'b1) begin
        state <= s0;
        y = '0;
        x = '0;
        cnt = '0;

        
    end else begin
        state <= state_c;
        x = x_c;
        y = y_c;
        cnt = cnt_c;
        
    end
end

always_comb
begin
    in_rd_en  = 1'b0;
    out_wr_en = 1'b0;
    out_din   = 8'b0;
    state_c   = state;
    cnt_c = cnt;
    h_grad = '0;
    v_grad = '0;
    out_hold = '0;
    out_din_temp = '0;





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
                cnt_c = cnt +1;
                state_c = s1;
                end
            end
            else state_c = s2;

        end
        s2: begin
            if (in_empty == 1'b0) begin
                in_rd_en = 1'b1;
            end
            if (out_full == 1'b0)
            begin
                out_wr_en = 1'b1;
                x_c = $unsigned(x) + 1;
                if ($unsigned(x_c)>WIDTH) begin
                    x_c = '0;
                    y_c = $unsigned(y)+1;
                    if ($unsigned(y_c) > HEIGHT) begin
                        y_c = '0;
                    end
                end
                if ( ($unsigned(y) != 0) & ($unsigned(x) != 0) & ($unsigned(y) != HEIGHT-1 ) & ($unsigned(x) != WIDTH-1)) begin
                    for (int j = 0; j < 3; j++) begin
                        for (int i = 0; i < 3; i++) begin
                            //$display("hgrad:%x vgrad:%x\n", h_grad, v_grad);
                            //$display("%x", h_op[j][i]);
                            h_grad += buffer[j][i]*$signed(h_op[i][j]);
                            v_grad += buffer[j][i]*$signed(v_op[i][j]);
                        end
                    end
                    //$display("hgrad:%x vgrad:%x\n", h_grad, v_grad);
                    out_hold = abs(v_grad) + abs(h_grad);
                    out_din_temp = ($unsigned(out_hold) > 255)  ? 8'hFF  : out_hold[7:0];
                    out_din = out_din_temp;
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
    input logic enable,
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
    parameter LENGTH = IMG_WIDTH*2 +3;

    logic [LENGTH-1:0][WIDTH-1:0] shift_reg;
    //logic [WIDTH-1:0] data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9;

    assign data_1 = shift_reg[LENGTH-1];
    assign data_2 = shift_reg[LENGTH-2];
    assign data_3 = shift_reg[LENGTH-3];
    assign data_4 = shift_reg[IMG_WIDTH-1+3];
    assign data_5 = shift_reg[IMG_WIDTH-1+2];
    assign data_6 = shift_reg[IMG_WIDTH-1+1];
    assign data_7 = shift_reg[2];
    assign data_8 = shift_reg[1];
    assign data_9 = shift_reg[0];

    always_ff @(posedge clock or posedge reset)
    begin
    if (reset == 1'b1) begin
        shift_reg <= '0;
    end else begin
        if (enable == 1'b1) begin
        shift_reg[1442:1] <= shift_reg[1441:0];
        shift_reg[0] <= d_in;
        end
        
    end

end




endmodule