module fibonacci(
  input logic clk, 
  input logic reset,
  input logic [15:0] din,
  input logic start,
  output logic [15:0] dout,
  output logic done );

  // TODO: Add local logic signals
  enum logic [1:0] {init, calc, base} state, next_state;
  logic [15:0] n_1;
  logic [15:0] n_2;
  logic [15:0] n_1c;
  logic [15:0] n_2c;
  logic [15:0] dout_c;
  logic [15:0] count;
  logic [15:0] count_c;
  logic done_c;



  always_ff @(posedge clk, posedge reset)
  begin
    if ( reset == 1'b1 ) begin
       // TODO: Implement reset signals
       state <= init;
       n_1 <= 16'b0;
       n_2 <= 16'b0;
       count <= 16'b0;
       dout <= 16'b0;
       done <= 1'b0;

    end else begin
       // TODO: Implement clocked signals
       state <= next_state;
       n_1 <= n_1c;
       n_2 <= n_2c;
       count <= count_c;
       dout <= dout_c;
       done <= done_c;

    end
  end

  always_comb 
  begin
    next_state = state;
    n_1c = n_1;
    n_2c = n_2;
    dout_c = dout;
    done_c = done;
    count_c = count;
    case (state)
       // TODO: Implement FSM
       init:
        begin
          n_1c = 16'b1;
          n_2c = 16'b0;
          dout_c = 16'b1;
          count_c = 16'b1;
          if (start == 1'b1) begin
            done_c = 1'b0;
            if (din == 1) next_state = base;
            else next_state = calc;
          end else begin
            next_state = init;
            done_c = 1'b0;
          end
        end
      base:
      begin
        done_c = 1'b1;
        dout_c = 1'b1;
        next_state = init;
      end
      calc:
      begin
        if (count == din -1) begin
          dout_c = n_1c + n_2c;
          done_c = 1'b1;
          next_state = init;

        end else begin
          n_1c = dout;
          n_2c = n_1;
          dout_c = n_1c + n_2c;
          done_c = 1'b0;
          count_c = count + 1;
          next_state = calc;
        end


      
      end


    endcase
  end
endmodule
