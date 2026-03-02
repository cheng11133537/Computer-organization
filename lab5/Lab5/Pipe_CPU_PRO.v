// student ID:314512065
`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "Data_Memory.v"
`include "Decoder.v"
`include "Forwarding_Unit.v"
`include "Hazard_Detection.v"
`include "Instruction_Memory.v"
`include "MUX_2to1.v"
`include "MUX_3to1.v"
`include "Reg_File.v"
`include "Shift_Left_Two_32.v"
`include "Sign_Extend.v"
`include "Pipe_Reg.v"
`include "ProgramCounter.v"

`timescale 1ns / 1ps

module Pipe_CPU_PRO(
    clk_i,
    rst_i
);
    
input clk_i;
input rst_i;

// Internal signal
//Mux_PC wire
wire [31:0]Adder1_out;
wire [31:0]Adder2_out_s4;
wire Branch_s4;
wire ALU_zero_s4;
wire [31:0]PC_in;
//PC wire
wire [31:0]PC_out;
wire pc_write;
//IM wire
wire [31:0]IM_out;
//Reg IF_ID
wire if_flush;
wire ifid_write;
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
//MUX control wire
wire [1:0]ALU_op_s2;
wire RegWrite_s2;
wire ALUSrc_s2;
wire RegDst_s2;
wire Jump_s2;
wire Branch_s2;
wire BranchType_s2;
wire MemRead_s2;
wire MemWrite_s2;
wire MemtoReg_s2;
//Hazard wire 
wire idex_memread;
wire branch;
wire id_flush;
wire ex_flush;
//MUX_RegDst wire
wire RegDst_s3;
wire[4:0]RDaddr;
wire [31:0]IM_out_s3;
//AC wire
wire [1:0]ALU_op_s3;
wire [3:0]ALUCtrl;
//ALUSrc1 wire
wire [31:0]RSdata_s3;
wire [31:0]ALU_out_s4;
wire [1:0]forwarda;
wire [31:0]ALU_in1;
//ALUSrc2 wire
wire [31:0]RTdata_s3;
wire [1:0]forwardb;
wire [31:0]mux_3to1_out;
//ALUSrc0 wire
wire [31:0]SE_out_s3;
wire ALUSrc_s3;
wire [31:0]ALU_in2;
//ALU wire
wire [31:0]ALU_out;
wire ALU_zero;
wire overflow;
//Shifter2 wire
wire [31:0]shl1_out;
//Adder2 wire
wire [31:0]PC_out_s3;
wire [31:0]Adder2_out;
// MUX EXflush1 wire
wire RegWrite_flush;
wire MemtoReg_flush;
// MUX EXflush2 wire
wire Branch_flush;
wire MemRead_flush;
wire MemWrite_flush;
//Forwarding wire
wire RegWrite_s4;
wire [4:0]RDaddr_s4;
//DM wire
wire MemRead_s4;
wire MemWrite_s4;
wire [31:0]DM_out;
wire [31:0]mux_3to1_out_s4;
//MUX MemToReg wire
wire [31:0]ALU_out_s5;
wire [31:0]DM_out_s5;
wire MemtoReg_s5;
//New Reg100
wire [31:0]PC_out_s2;

//Reg210 wire
wire Branch_s3;
wire MemRead_s3;
wire MemWrite_s3;
wire RegWrite_s3;
//Reg 220 wire
wire MemtoReg_s3;

//Reg 221 wire 
wire MemtoReg_s4;

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
        .pc_write(pc_write),
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

Pipe_Reg #(
    .size(32*2)
    ) IF_ID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(if_flush),
    .write(ifid_write),
    .data_i({PC_out, IM_out}),
    .data_o({PC_out_s2, IM_out_s2})
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
  .MemRead_o    (MemRead),
  .MemWrite_o   (MemWrite),
  .MemtoReg_o   (MemtoReg)
);

MUX_2to1 #(
    .size(9)
) Mux_control( 
    .data0_i({ALU_op,ALUSrc,RegWrite,RegDst,Branch,MemRead,MemWrite,MemtoReg}),
    .data1_i(9'd0),
    .select_i(id_flush),
    .data_o({ALU_op_s2,ALUSrc_s2,RegWrite_s2,RegDst_s2,Branch_s2,MemRead_s2,MemWrite_s2,MemtoReg_s2})
);

Pipe_Reg #(
    .size(152)
    ) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(1'b0),
    .write(1'b1),
    .data_i({ALU_op_s2,ALUSrc_s2,RegWrite_s2,RegDst_s2,Branch_s2,MemRead_s2,MemWrite_s2,MemtoReg_s2,PC_out_s2,RSdata,RTdata,SE_out,
    IM_out_s2[25:21],IM_out_s2[20:16],IM_out_s2[15:11]}),
    .data_o({ALU_op_s3,ALUSrc_s3,RegWrite_s3,RegDst_s3,Branch_s3,MemRead_s3,MemWrite_s3,MemtoReg_s3,PC_out_s3,RSdata_s3,RTdata_s3,SE_out_s3,
    IM_out_s3[25:21],IM_out_s3[20:16],IM_out_s3[15:11]})
);
// EX stage
Shift_Left_Two_32 Shifter2(
	.data_i(SE_out_s3),
	.data_o(shl1_out)
);

ALU ALU (
      .src1_i(ALU_in1),
      .src2_i(ALU_in2),
      .ctrl_i(ALUCtrl),
      .result_o(ALU_out),
      .jump_o(ALU_zero)
);

ALU_Ctrl AC (
      .funct_i(SE_out_s3[5:0]), 
      .ALUOp_i(ALU_op_s3),
      .ALUCtrl_o(ALUCtrl)
);

MUX_2to1 #(
    .size(5)
    )Mux_RegDst(
      .data0_i (IM_out_s3[20:16]),
      .data1_i (IM_out_s3[15:11]),
      .select_i(RegDst_s3),
      .data_o  (RDaddr) 
);


MUX_3to1 #(
    .size(32)
    ) MUX_ALU_Src1 (
    .data0_i (RSdata_s3),                 
    .data1_i (ALU_out_s4),                
    .data2_i (RDdata),     
    .select_i(forwarda),
    .data_o  (ALU_in1)
);

MUX_3to1 #(
    .size(32)
    ) MUX_ALU_Src2 (
    .data0_i (RTdata_s3),                 
    .data1_i (ALU_out_s4),                
    .data2_i (RDdata),     
    .select_i(forwardb),
    .data_o  (mux_3to1_out)
);

MUX_2to1 #(
    .size(32)
    ) MUX_ALU_Src0(
      .data0_i (mux_3to1_out),
      .data1_i (SE_out_s3),
      .select_i(ALUSrc_s3),
      .data_o  (ALU_in2) 
);

Adder Adder2(
      .src1_i(PC_out_s3),
      .src2_i(shl1_out),
      .sum_o (Adder2_out)
);

MUX_2to1 #(
    .size(2)
    ) Mux_EXflush1( 
    .data0_i({RegWrite_s3,MemtoReg_s3}),
    .data1_i(2'd0),
    .select_i(ex_flush),
    .data_o({RegWrite_flush,MemtoReg_flush})
);

MUX_2to1 #(
    .size(3)
    ) Mux_EXflush2( 
    .data0_i({Branch_s3,MemRead_s3,MemWrite_s3}),
    .data1_i(3'd0),
    .select_i(ex_flush),
    .data_o({Branch_flush,MemRead_flush,MemWrite_flush})
);

Pipe_Reg #(
    .size(107)
) EX_MEM( 
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(1'b0),
    .write(1'b1),
    .data_i({RegWrite_flush,
             MemtoReg_flush,
             Branch_flush,
             MemRead_flush,
             MemWrite_flush,
             Adder2_out,
             ALU_zero,
             ALU_out,
             mux_3to1_out,
             RDaddr}),
    .data_o({RegWrite_s4,
             MemtoReg_s4,
             Branch_s4,
             MemRead_s4,
             MemWrite_s4,
             Adder2_out_s4,
             ALU_zero_s4,
             ALU_out_s4,
             mux_3to1_out_s4,
             RDaddr_s4})
);
// MEM stage
Data_Memory DM(
	.clk_i(clk_i), 
	.addr_i(ALU_out_s4), 
	.data_i(mux_3to1_out_s4), 
	.MemRead_i(MemRead_s4), 
	.MemWrite_i(MemWrite_s4), 
	.data_o(DM_out)
);

Pipe_Reg #(
    .size(71)
    ) MEM_WB( 
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(1'b0),
    .write(1'b1),
    .data_i({RegWrite_s4,
             MemtoReg_s4,
             DM_out,
             ALU_out_s4,
             RDaddr_s4}),
    .data_o({RegWrite_s5,
             MemtoReg_s5,
             DM_out_s5,
             ALU_out_s5,
             RDaddr_s5})
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
Forwarding_Unit Forwarding(
    .regwrite_mem(RegWrite_s4),
    .regwrite_wb(RegWrite_s5),
    .idex_regs(IM_out_s3[25:21]),
    .idex_regt(IM_out_s3[20:16]),
    .exmem_regd(RDaddr_s4),
    .memwb_regd(RDaddr_s5),
    .forwarda(forwarda),
    .forwardb(forwardb)
);

Hazard_Detection Hazards(
    .memread(MemRead_s3),
    .ifid_regs(IM_out_s2[25:21]),
    .ifid_regt(IM_out_s2[20:16]),
    .idex_regt(IM_out_s3[20:16]),
    .branch(Branch_s4&ALU_zero_s4),
    .pcwrite(pc_write),
    .ifid_write(ifid_write),
    .ifid_flush(if_flush),
    .idex_flush(id_flush),
    .exmem_flush(ex_flush)
);
endmodule