// student ID:314512065
`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "Reg_File.v"
`include "Data_Memory.v"
`include "Decoder.v"
`include "Instruction_Memory.v"
`include "MUX_2to1.v"
`include "Pipe_Reg.v"
`include "ProgramCounter.v"
`include "Shift_Left_Two_32.v"
`include "Sign_Extend.v"

`timescale 1ns / 1ps

module Pipe_CPU(
    clk_i,
    rst_i
    );

input clk_i;
input rst_i;

// TO DO

// Internal signal
//Mux_PC wire
wire [31:0]Adder1_out;
wire [31:0]Adder2_out_s4;
wire Branch_s4;
wire ALU_zero_s4;
wire [31:0]PC_in;
//PC wire
wire [31:0]PC_out;
//IM wire
wire [31:0]IM_out;
//SE wire
wire [31:0]IM_out_s2;
wire [31:0]SE_out;
//Register wire
wire[4:0] RDaddr_s5;
wire [31:0]RDdata;
wire RegWrite_s5;
wire [31:0]RSdata;
wire [31:0]RTdata;
//Decoder wire
wire [1:0]ALU_op;
wire RegWrite;
wire ALUSrc;
wire RegDst;
wire Jump;
wire Branch;
wire BranchType;
wire MemRead;
wire MemWrite;
wire MemtoReg;
//MUX_RegDst wire
wire RegDst_s3;
wire[4:0]RDaddr;
wire [31:0]IM_out_s3;
//AC wire
wire[31:0]SE_out_s3;
wire [1:0]ALU_op_s3;
wire [3:0]ALUCtrl;
//Src wire
wire[31:0]RSdata_s3;
wire[31:0]RTdata_s3;
wire ALUSrc_s3;
wire [31:0]ALU_Src2;
//ALU wire
wire[31:0]ALU_out;
wire ALU_zero;
wire overflow;
// Shifter1 wire
wire[31:0]shl1_out;
//Adder2 wire
wire [31:0]PC_out_s3;
wire [31:0]Adder2_out;
//Data Memory wire
wire [31:0] ALU_out_s4;
wire[31:0] RTdata_s4;
wire MemRead_s4;
wire MemWrite_s4;
wire[31:0] DM_out;
//Mux_MemToReg wire
wire [31:0] ALU_out_s5;
wire [31:0] DM_out_s5;
wire MemtoReg_s5;
//  Reg150 wire
wire [4:0]RDaddr_s4;
// Reg210 wire
wire Branch_s3;
wire MemRead_s3;
wire MemWrite_s3;
wire RegWrite_s3;
// Reg 211 wire
wire RegWrite_s4;
//Reg 220 wire
wire [1:0]ALUOp_s3;
wire MemtoReg_s3;
//Reg 221 wire
wire MemtoReg_s4;
//Reg 223 wire
wire [31:0]PC_out_s2;
// IF stage
MUX_2to1 #(
    .size(32)
    ) Mux_PC(
    .data0_i (Adder1_out),
    .data1_i (Adder2_out_s4),
    .select_i(Branch_s4&ALU_zero_s4),
    .data_o  (PC_in) 
);

ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(PC_in), 
        .pc_out_o(PC_out) 
);

Instruction_Memory  IM(
        .addr_i(PC_out),  
        .instr_o(IM_out)    
);
Adder Adder1(
	.src1_i(32'd4),
	.src2_i(PC_out),
	.sum_o(Adder1_out)
);
// ID stage
Sign_Extend SE (
      .data_i(IM_out_s2[15:0]),
      .data_o(SE_out)
);

Reg_File RF(
        .clk_i(clk_i),
        .rst_i(rst_i) ,     
        .RSaddr_i(IM_out_s2[25:21]),
        .RTaddr_i(IM_out_s2[20:16]),
        .RDaddr_i(RDaddr_s5), 
        .RDdata_i(RDdata),        
        .RegWrite_i(RegWrite_s5), 
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata) 
);

Decoder Decoder (
  .instr_op_i   (IM_out_s2[31:26]),
  .funct_i      (IM_out_s2[5:0]),        
  .ALU_op_o     (ALU_op),
  .ALUSrc_o     (ALUSrc),
  .RegWrite_o   (RegWrite),
  .RegDst_o     (RegDst),
  .Branch_o     (Branch),
  .Jump_o       (Jump),
  .MemRead_o    (MemRead),
  .MemWrite_o   (MemWrite),
  .MemtoReg_o   (MemtoReg),
  .BranchType_o (BranchType)
);
// EX stage
MUX_2to1 #(
    .size(5)
    ) Mux_RegDst(
    .data0_i (IM_out_s3[20:16]),
    .data1_i (IM_out_s3[15:11]),
    .select_i(RegDst_s3),
    .data_o  (RDaddr) 
);

ALU_Ctrl AC (
      .funct_i(SE_out_s3[5:0]),
      .ALUOp_i(ALU_op_s3),
      .ALUCtrl_o(ALUCtrl)
);

MUX_2to1 #(
      .size(32)
  ) ALU_Src (
      .data0_i (RTdata_s3),
      .data1_i (SE_out_s3),
      .select_i(ALUSrc_s3),
      .data_o  (ALU_Src2)
);

ALU ALU (
      .src1_i(RSdata_s3),
      .src2_i(ALU_Src2),
      .ctrl_i(ALUCtrl),
      .result_o(ALU_out),
      .zero_o(ALU_zero),
      .overflow(overflow)
);

Shift_Left_Two_32 Shifter1(
	.data_i(SE_out_s3),
	.data_o(shl1_out)
);

Adder Adder2(
      .src1_i(PC_out_s3),
      .src2_i(shl1_out),
      .sum_o (Adder2_out)
);
// MEM stage
Data_Memory DM(
	.clk_i(clk_i), 
	.addr_i(ALU_out_s4), 
	.data_i(RTdata_s4), 
	.MemRead_i(MemRead_s4), 
	.MemWrite_i(MemWrite_s4), 
	.data_o(DM_out)
);
// WB stage
MUX_2to1 #(
      .size(32)
) Mux_MemToReg (
      .data0_i(ALU_out_s5), 
      .data1_i(DM_out_s5),
      .select_i(MemtoReg_s5),
      .data_o(RDdata) 
);
// Components
Pipe_Reg #(
    .size(1)
    ) reg110(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i(ALU_zero),
	.data_o(ALU_zero_s4)
);

Pipe_Reg #(
    .size(5 * 2)
    ) reg150(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({RDaddr, RDaddr_s4}),
	.data_o({RDaddr_s4, RDaddr_s5})
);

Pipe_Reg #(
    .size(32 * 2)
    ) reg190(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({IM_out, IM_out_s2}),
	.data_o({IM_out_s2, IM_out_s3})
);

Pipe_Reg #(
    .size(32 * 3)
    ) reg191(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({RSdata, RTdata,RTdata_s3}),
	.data_o({RSdata_s3,RTdata_s3,RTdata_s4})
);

Pipe_Reg #(
    .size(32 * 2)
    ) reg192(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({ALU_out, ALU_out_s4}),
	.data_o({ALU_out_s4, ALU_out_s5})
);

Pipe_Reg #(
    .size(32 * 1)
    ) reg193(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({Adder2_out}),
	.data_o({Adder2_out_s4})
);

Pipe_Reg #(
    .size(32 * 2)
    ) reg194(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({SE_out, DM_out}),
	.data_o({SE_out_s3, DM_out_s5})
);

Pipe_Reg #(
    .size(1 * 5)
    ) reg210(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({ALUSrc, Branch, MemRead, MemWrite, RegWrite}),
	.data_o({ALUSrc_s3, Branch_s3, MemRead_s3, MemWrite_s3, RegWrite_s3})
);

Pipe_Reg #(
    .size(1 * 5)
    ) reg211(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({Branch_s3, MemRead_s3, MemWrite_s3, RegWrite_s3, RegWrite_s4}),
	.data_o({Branch_s4, MemRead_s4, MemWrite_s4, RegWrite_s4, RegWrite_s5})
);

Pipe_Reg #(
    .size(2)
    ) reg220(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({ALU_op}),
	.data_o({ALU_op_s3})
);

Pipe_Reg #(
    .size(1 * 2)
    ) reg222(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({MemtoReg, RegDst}),
	.data_o({MemtoReg_s3, RegDst_s3})
);

Pipe_Reg #(
    .size(1 * 2)
    ) reg221(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({MemtoReg_s3, MemtoReg_s4}),
	.data_o({MemtoReg_s4, MemtoReg_s5})
);


Pipe_Reg #(
    .size(32 * 2)
    ) reg223(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({PC_out, PC_out_s2}),
	.data_o({PC_out_s2, PC_out_s3})
);

endmodule