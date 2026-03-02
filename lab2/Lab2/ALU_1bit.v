//Student ID: 314512065
`timescale 1ns/1ps
`include "MUX_2to1.v" // Include the 2-to-1 MUX module
`include "MUX_4to1.v" // Include the 4-to-1 MUX module

module ALU_1bit(
    input         src1,       // 1-bit source 1 (input)
    input         src2,       // 1-bit source 2 (input)
    input         less,       // 1-bit less (for SLT operation, input)
    input         Ainvert,    // 1-bit A_invert control (input)
    input         Binvert,    // 1-bit B_invert control (input)
    input         cin,        // 1-bit carry in (input)
    input  [1:0]  operation,  // 2-bit operation select (input)
    output wire  result,     // 1-bit result (output) 
    output reg    cout        // 1-bit carry out (output)
    );
	wire A, B;
    wire andWire, orWire, sum;

    MUX_2to1 M1(src1, ~src1, Ainvert, A);
    MUX_2to1 M2(src2, ~src2, Binvert, B);

    assign andWire = A & B;
    assign orWire  = A | B;
    assign sum     = A ^ B ^ cin;
    MUX_4to1 M3(orWire, andWire, sum, less, operation, res);

    always @(*) begin
        case (operation)
            2'b10: cout = (A & B) | (A & cin) | (B & cin); // add/sub
            default: cout = 1'b0;
        endcase
    end

endmodule