// student ID:314512065
module ALU(
	src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o,
	overflow
);
     
// I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output reg [32-1:0]	 result_o;
output          zero_o;
output           overflow;

// Internal signals
assign zero_o = (result_o == 32'b0);

assign overflow = ((src1_i[31] == 0 && src2_i[31] == 0 && result_o[31] == 1) || (src1_i[31] == 1 && src2_i[31] == 1 && result_o[31] == 0)) ? 1:0;

// Main function
always @(*) begin
	case (ctrl_i)
      0:  result_o = src1_i | src2_i;
      1:  result_o = src1_i & src2_i;
      2:  result_o = src1_i + src2_i;
      6:  result_o = src1_i - src2_i;
      7:  result_o = $signed(src1_i) < $signed(src2_i) ? 32'd1 : 32'd0;
	  8:  result_o = src1_i << src2_i[4:0];
      9:  result_o = $signed(src1_i) < $signed(src2_i) ? 32'd0 : 32'd1;
      10: result_o = src1_i >> src2_i[4:0];
      13: result_o = ~(src1_i | src2_i);
      default: result_o = 32'd0;
    endcase
end

endmodule