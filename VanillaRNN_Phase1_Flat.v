`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2026 12:36:57
// Design Name: 
// Module Name: VanillaRNN_Phase1_Flat
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
module VanillaRNN #(
    parameter DATA_W = 8,     // Bit width
    parameter I = 4,          // Input vector size
    parameter H = 4           // Hidden state size
)(
    input clk,
    input reset,
    input valid_in,
    input signed [DATA_W*I-1:0] x_in_flat,   // Flattened input vector
    output reg signed [DATA_W*H-1:0] h_out_flat // Flattened hidden state
);

    // Internal arrays
    reg signed [DATA_W-1:0] x_in [0:I-1];
    reg signed [DATA_W-1:0] h [0:H-1];
    reg signed [DATA_W-1:0] W_x [0:H-1][0:I-1];
    reg signed [DATA_W-1:0] W_h [0:H-1][0:H-1];
    reg signed [DATA_W-1:0] b [0:H-1];

    integer i, j;
 integer sum;
    // Unpack flattened input
    always @(*) begin
        for (i = 0; i < I; i = i + 1)
            x_in[i] = x_in_flat[(i+1)*DATA_W-1 -: DATA_W];
    end

    // Simple linear tanh approximation
    function signed [DATA_W-1:0] tanh_approx;
        input signed [DATA_W-1:0] x;
        begin
            if (x > 127)
                tanh_approx = 127;
            else if (x < -128)
                tanh_approx = -128;
            else
                tanh_approx = x;
        end
    endfunction

    // Initialize weights
    initial begin
        for (i = 0; i < H; i = i + 1) begin
            h[i] = 0;
            b[i] = 0;
            for (j = 0; j < I; j = j + 1) W_x[i][j] = i + j + 1;
            for (j = 0; j < H; j = j + 1) W_h[i][j] = i - j;
        end
    end

    // RNN computation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < H; i = i + 1) begin
                h[i] <= 0;
            end
        end else if (valid_in) begin
            for (i = 0; i < H; i = i + 1) begin
               
                sum = b[i];
                for (j = 0; j < I; j = j + 1)
                    sum = sum + W_x[i][j] * x_in[j];
                for (j = 0; j < H; j = j + 1)
                    sum = sum + W_h[i][j] * h[j];
                h[i] <= tanh_approx(sum[DATA_W-1:0]);
            end
        end
    end

    // Pack hidden state to output
    always @(*) begin
        for (i = 0; i < H; i = i + 1)
            h_out_flat[(i+1)*DATA_W-1 -: DATA_W] = h[i];
    end

endmodule