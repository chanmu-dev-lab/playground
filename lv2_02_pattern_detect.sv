/*
For each clock cycle, 1-bit data is input. 
When the sequence "1011" is received in order, output a 1-bit flag at the moment the last data bit is entered. 
Write the Verilog code in two types.
1. Type without using FSM
2. Type using FSM
*/

module pattern_detector (
    input wire              clk,
    input wire              rstn,
    input wire              i_in,
    output wire             o_flag
    );

    timeunit      1ns;
    timeprecision 1ps;

    // 1011 pattern
    // 1. FSM
    `ifdef FSM_CODING
        typedef enum logic [1:0] {
            S0, S1, S2, S3
        } state_t;

        state_t state_n, state_c;
        always_comb begin
            state_n = S0;
            case(state_c) 
                S0: if (i_in) state_n = S1;
                    else state_n = S0;
                S1: if (i_in) state_n = S1;
                    else state_n = S2;
                S2: if (i_in) state_n = S3;
                    else state_n = S0;
                S3: if (i_in) state_n = S1;
                    else state_n = S0;
                default: state_n = S0;
            endcase
        end

        always_ff @(posedge clk, negedge rstn) begin
            if (!rstn) begin
                state_c <= S0;
            end else begin
                state_c <= state_n;
            end
        end

        assign o_flag = (state_c == S3) && i_in;

    `else // not FSM
        logic shift_reg [3:0];
        always_ff @(posedge clk, nededge rstn) begin
            if (!rstn) begin
                shift_reg <= 4'b0;
            end else begin
                shift_reg[0] <= i_in;
                shift_reg[1] <= shift_reg[0];
                shift_reg[2] <= shift_reg[1];
                shift_reg[3] <= shift_reg[2];
            end
        end

        assign o_flag = (shift_reg == 4'b1011); 
    `endif

endmodule   