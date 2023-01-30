
module motion_detect #(  
    parameter DATA_WIDTH = 32
) (
    input  logic clock,
    input  logic reset,
    input  logic [DATA_WIDTH-1:0] mask_dout,
    input  logic mask_empty,
    output logic mask_rd_en,
    input  logic [DATA_WIDTH-1:0] base_dout,
    input  logic base_empty,
    output logic base_rd_en,
    output logic [DATA_WIDTH-1:0] z_din,
    input  logic z_full,
    output logic z_wr_en
);

typedef enum logic [0:0] {s0, s1} state_t;
state_t state, state_c;
logic [DATA_WIDTH-1:0] sum, sum_c;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        state <= s0;
        sum <= '0;
    end else begin
        state <= state_c;
        sum <= sum_c;
    end
end

always_comb begin
    z_din = 'b0;
    z_wr_en = 1'b0;
    mask_rd_en = 1'b0;
    base_rd_en = 1'b0;
    sum_c = sum;
    state_c = state;

    case (state)
        s0: begin
            if (mask_empty == 1'b0 && base_empty == 1'b0) begin
                sum_c = (mask_dout)? 24'hff00ff:base_dout;
                mask_rd_en = 1'b1;
                base_rd_en = 1'b1;
                state_c = s1;
            end
        end

        s1: begin
            if (z_full == 1'b0) begin
                z_din = sum;
                z_wr_en = 1'b1;
                state_c = s0;
            end
        end

        default: begin
            state_c = s0;
            sum_c = 'x;
        end
    endcase
end

endmodule