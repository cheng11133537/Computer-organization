// student ID:314512065
module ALU(
	src1_i,
	src2_i,
	ctrl_i,
	result_o,
	jump_o
);
     
// I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output reg [32-1:0]	 result_o;
output reg          jump_o;

// Internal signals
// Main function
always @(*) begin
	case (ctrl_i)
      0: begin
        result_o = src1_i | src2_i;
        jump_o=0;
      end
      1: begin
        result_o = src1_i & src2_i;
        jump_o=0;
      end
      2: begin
        result_o = src1_i + src2_i;
        jump_o=0;
      end

      6:  begin
        result_o = src1_i - src2_i;
        jump_o=0;
      end
      7:  begin
        result_o = $signed(src1_i) < $signed(src2_i) ? 32'd1 : 32'd0;
        jump_o=0;
      end
	    8:  begin
        result_o = 0;
        jump_o = (src1_i != src2_i) ? 1 : 0;
      end
      9:  begin
        result_o = 0;
        jump_o = (src1_i == src2_i) ? 1 : 0;
      end
      10: begin
        result_o = 0;
        jump_o = (src1_i >= src2_i) ? 1 : 0;
      end
      11: begin
        result_o = 0;
        jump_o = (src1_i > src2_i) ? 1 : 0;
      end
      13: begin
        result_o = ~(src1_i | src2_i);
        jump_o=0;
      end
      default: begin
        result_o = 32'd0;
        jump_o=0;
      end
    endcase
end

endmodule