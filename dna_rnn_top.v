module dna_rnn_top(

input clk,
input reset,
input [1:0] dna_base,

output [15:0] rnn_out

);

wire [3:0] encoded;

dna_encoder enc(

.dna_base(dna_base),
.encoded(encoded)

);

rnn_cell rnn(

.clk(clk),
.reset(reset),
.x(encoded),
.h(rnn_out)

);

endmodule