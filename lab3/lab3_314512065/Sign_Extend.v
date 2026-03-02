// student ID:314512065
module Sign_Extend(
    input  [15:0] data_i,
    output reg [31:0] data_o
);

always @(*) begin
    if (data_i[15] == 1'b1)
        data_o = {16'hFFFF, data_i}; 
    else
        data_o = {16'h0000, data_i}; 
end

endmodule
