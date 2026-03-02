module Shifter (
    result,
    lR,
    shamt,
    Src
);
output [31:0] result;
input lR;
input [5-1:0] shamt;
input [32-1:0] Src;
wire [31:0] result;
// lr = 1 -> shift right
assign result = lR ? (Src >> shamt) : (Src << shamt); 
endmodule
