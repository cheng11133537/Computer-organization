//Student ID: 314512065
`timescale 1ns/1ps
`include "ALU_1bit.v"

module ALU(
	input                   rst_n,         // negative reset            (input)
	input	     [32-1:0]	src1,          // 32 bits source 1          (input)
	input	     [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output wire   [32-1:0]	result,        // 32 bits result            (output)
	output reg              zero,          // 1 bit when the output is 0, zero must be set (output)
	output reg              cout,          // 1 bit carry out           (output)
	output reg              overflow       // 1 bit overflow            (output)
	);

    wire set;
	wire [32:1] carry;
	ALU_1bit a0(src1[0],src2[0],set,ALU_control[3],ALU_control[2],ALU_control[2],ALU_control[1:0],result[0],carry[1]);

    genvar i;
	
	generate
		for(i=1;i<31;i=i+1) begin
			ALU_1bit ai(src1[i],src2[i],1'b0,ALU_control[3],ALU_control[2],carry[i],ALU_control[1:0],result[i],carry[i+1]);
		end
	endgenerate

	ALU_1bit a31(src1[31],src2[31],1'b0,ALU_control[3],ALU_control[2],carry[31],ALU_control[1:0],result[31],carry[32]);

	//wire Add;
	wire signed [31:0] signed_src1 = src1;
	wire signed [31:0] signed_src2 = src2;
	assign set = (signed_src1 < signed_src2);

	always @(*) begin
		zero = (result == 32'b0);
    	cout = 0;
    	overflow = 0;
    	if (ALU_control == 4'h2 || ALU_control == 4'h6) begin
        	cout = carry[32];
        	overflow = carry[32] ^ carry[31];  // or signed overflow detection
    	end
	end

endmodule