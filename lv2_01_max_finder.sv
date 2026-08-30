/*
Design a Verilog module that, starting right after reset is deasserted, 
outputs the maximum value along with its valid signal among the most recent five valid input data.
*/

`timescale 1ns/1ps;

module max_finder (
    input wire              clk,
    input wire              rst,
    input wire              valid,
    input wire [WIDTH-1:0]  data,
    output logic             max_valid,
    output wire  [WIDTH-1:0] max_out
    );

    localparam int WIDTH    = 32;
    localparam int COUNT    = 5;

    // buffer : max finder 
    logic [WIDTH-1:0]       buffer; // prev vs new
    logic [clog2(COUNT)-1:0] counter;

    // buffer store & count 굳이 5개를 저장할 필요가 없음
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            buffer <= (WIDTH){1'b0};
            counter <= 3'b0;
        end else begin
            if (valid) begin
                if (counter < COUNT-1) counter <= counter + 1;
                if (buffer < data) begin
                    buffer <= data;
                end
            end
        end
    end

    wire max_flag = (conuter == COUNT-1);

    // counter -> max_valid 
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            max_valid   <= 1'b0;
        end else if (max_flag) begin
            max_valid   <= 1'b1;
        end
    end

    assign max_out = (max_valid ? buffer : (WIDTH){1'b0});
    
endmodule