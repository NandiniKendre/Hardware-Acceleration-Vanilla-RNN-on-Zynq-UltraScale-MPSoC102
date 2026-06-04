`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2026 12:37:43
// Design Name: 
// Module Name: tb_VanillaRNN_Phase1_Flat_Clean
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_VanillaRNN;

    parameter DATA_W = 8;
    parameter I = 4;
    parameter H = 4;

    reg clk;
    reg reset;
    reg valid_in;
    reg signed [DATA_W*I-1:0] x_in_flat;
    wire signed [DATA_W*H-1:0] h_out_flat;

    integer t;

    // Instantiate RNN
    VanillaRNN #(DATA_W, I, H) uut (
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .x_in_flat(x_in_flat),
        .h_out_flat(h_out_flat)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns period

    // Define 4 timesteps of input as flattened vectors
    reg signed [DATA_W*I-1:0] input_seq_flat [0:3];

initial begin
    // timestep 0
    input_seq_flat[0] = 0;
    input_seq_flat[0][DATA_W*4-1 -: DATA_W] = 8'd10;   // MSB
    input_seq_flat[0][DATA_W*3-1 -: DATA_W] = -8'd5;
    input_seq_flat[0][DATA_W*2-1 -: DATA_W] = 8'd0;
    input_seq_flat[0][DATA_W*1-1 -: DATA_W] = 8'd3;    // LSB

    // timestep 1
    input_seq_flat[1] = 0;
    input_seq_flat[1][DATA_W*4-1 -: DATA_W] = -8'd20;
    input_seq_flat[1][DATA_W*3-1 -: DATA_W] = 8'd10;
    input_seq_flat[1][DATA_W*2-1 -: DATA_W] = 8'd5;
    input_seq_flat[1][DATA_W*1-1 -: DATA_W] = -8'd2;

    // timestep 2
    input_seq_flat[2] = 0;
    input_seq_flat[2][DATA_W*4-1 -: DATA_W] = 8'd30;
    input_seq_flat[2][DATA_W*3-1 -: DATA_W] = -8'd15;
    input_seq_flat[2][DATA_W*2-1 -: DATA_W] = 8'd10;
    input_seq_flat[2][DATA_W*1-1 -: DATA_W] = 8'd5;

    // timestep 3
    input_seq_flat[3] = 0;
    input_seq_flat[3][DATA_W*4-1 -: DATA_W] = -8'd40;
    input_seq_flat[3][DATA_W*3-1 -: DATA_W] = 8'd20;
    input_seq_flat[3][DATA_W*2-1 -: DATA_W] = -8'd5;
    input_seq_flat[3][DATA_W*1-1 -: DATA_W] = 8'd10;
end

    // Apply reset and feed input sequence
    initial begin
        reset = 1;
        valid_in = 0;
        x_in_flat = 0;

        #10;
        reset = 0;

        for (t = 0; t < 4; t = t + 1) begin
            x_in_flat = input_seq_flat[t];
            valid_in = 1;
            #10; // wait 1 clock cycle
        end

        valid_in = 0;
        #20;
        $finish;
    end

    // Monitor inputs and hidden outputs
    initial begin
        $display("Time\tclk\tx_in_flat\t\th_out_flat");
        $monitor("%0t\t%b\t%b\t%b", $time, clk, x_in_flat, h_out_flat);
    end

endmodule