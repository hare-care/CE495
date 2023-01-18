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

typedef enum logic [1:0] {init, i_cond, j_cond, k_cond, main} state_t;
state_t state, next_state;
logic [ADDR_WIDTH-1:0] i, i_c, j, j_c, k, k_c;
logic [DATA_WIDTH-1:0] add_hold, add_hold_c;
logic done_c;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        state <= init;
        done <= 1'b0;
        i <= '0;
        j <= '0;
        k <= '0;
        add_hold <= '0;
    end else begin
        state <= state_c;
        done <= done_c;
        i <= i_c;
        j <= j_c;
        k <= k_c;
        add_hold <= add_hold_c;
    end
end

always_comb begin
    z_din = 'b0;
    z_wr_en = 'b0;
    z_addr = 'b0;
    x_addr = 'b0;
    y_addr = 'b0;

    state_c = state;
    i_c = i;
    j_c = j;
    k_c = k;
    done_c = done;

    case (state)
        init: begin
            i_c = '0;
            j_c = '0;
            k_c = '0;
            if (start == 1'b1) begin
                state_c = i_cond;
                done_c = 1'b0;
            end else begin
                state_c = init;
            end
        end

        i_cond: begin
            if ($unsigned(i) < $unsigned(MATRIX_SIZE)) begin
                state_c = j_cond;
            end else begin 
                done_c = 1'b1;
                state_c = init;
            end
        end

        j_cond: begin
            if ($unsigned(j) < $unsigned(MATRIX_SIZE)) begin
                state_c = k_cond;
            end else begin
                done_c = 0'b1;
                state_c = i_cond;
            end

        end

        k_cond: begin
            if ($unsigned(k) < $unsigned(MATRIX_SIZE)) begin
                x_addr = i*MATRIX_SIZE + k;
                y_addr = k*MATRIX_SIZE +j;
                state_c = main;
            end else begin
                z_din = add_hold;
                z_addr = i*MATRIX_SIZE + j;
                z_wr_en = 1'b1;
                done_c = 0'b1;
                add_hold_c = '0;
                state_c = j_cond;
            end
        end

        main: begin
            add_hold_c = add_hold + $signed(y_dout) * $signed(x_dout);
            k_c = k +'b1;
            state_c = k_cond;
        end
    endcase
end
endmodule
