// student ID:314512065
`include "ProgramCounter.v"
`include "Instr_Memory.v"
`include "Reg_File.v"
`include "Data_Memory.v"
`include "Adder.v"
`include "Mux_2to1.v"
`include "Mux_3to1.v"
`include "Decoder.v"
`include "ALU_Ctrl.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Shift_Left_Two_32.v"
`include "Shifter.v"

module Simple_Single_CPU(
      clk_i,
	rst_i
);
		
// I/O port
input         clk_i;
input         rst_i;

// Internal Signals
wire [31:0] jr_into_pc;
wire [31:0] pc_o;
wire [31:0] add_o;
wire [31:0] add_add_o;

wire [31:0] instr;
wire [31:0] ex_instr;
wire[31:0] Branch_into_mux2;

wire RegWrite_o;
wire [2-1:0] ALU_op_o;
wire ALUSrc_o;
wire RegDst_o;
wire Jump_o;
wire Branch_o;
wire BranchType_o;
wire MemRead_o;
wire MemWrite_o;
wire MemtoReg_o;

wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] write_data;

wire [31:0] ALU_in;
wire [31:0] shift_out;

wire [1:0] FURslt_o;
wire lR_o;

wire [4:0] write_Reg;
wire [3:0] ALUCtrl_o;
wire [31:0] result_o;
wire zero_o;
wire overflow;

wire [31:0] mux3to1out;
wire [31:0] dm_out;

wire Jal;
wire [5:0]op=instr[31:26];
wire [5:0]funct=instr[5:0];
wire isR=(op==6'b000000);

// Components

ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(next_pc), 
        .pc_out_o(pc_o) 
);

Adder A1 (
      .src1_i(pc_o),
      .src2_i(32'd4),
      .sum_o (add_o)
);

Adder A2(
      .src1_i(pc_o),
      .src2_i(ex_instr << 2),
      .sum_o (add_add_o)
);
wire take_branch = Branch_o & (BranchType_o ? ~zero_o : zero_o);

MUX_2to1 #(
    .size(32)
) Mux_branch (
      .data0_i (add_o),
      .data1_i (add_add_o),
      .select_i(take_branch),
      .data_o  (Branch_into_mux2)
);
wire [31:0] j_target = {add_o[31:28], instr[25:0], 2'b00};

MUX_2to1 #(
    .size(32)
) Mux_jump (
      .data0_i (Branch_into_mux2),
      .data1_i (j_target), 
      .select_i(Jump_o),
      .data_o  (jr_into_pc)
);

wire isJR = (instr[31:26]==6'b000000) && (instr[5:0]==6'b001100);
wire [31:0] next_pc = isJR ? read_data1 : jr_into_pc;

Instr_Memory IM(
        .pc_addr_i(pc_o),  
        .instr_o(instr)    
);

wire is_jal = (instr[31:26] == 6'b000011);; 
wire [4:0] write_Reg_pre; 

MUX_2to1 #(
      .size(5)
) Mux_Write_Reg (
      .data0_i (instr[20:16]),
      .data1_i (instr[15:11]),
      .select_i(RegDst_o),
      .data_o  (write_Reg_pre) 
);

assign write_Reg = is_jal ? 5'd31 : write_Reg_pre;  

Reg_File Registers(
        .clk_i(clk_i),
        .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]),
        .RTaddr_i(instr[20:16]),
        .RDaddr_i(write_Reg), 
        .RDdata_i(write_data),
        .RegWrite_i(RegWrite_o),
        .RSdata_o(read_data1),  
        .RTdata_o(read_data2) 
);

Decoder Decoder (
  .instr_op_i   (instr[31:26]),
  .funct_i      (instr[5:0]),        
  .ALU_op_o     (ALU_op_o),
  .ALUSrc_o     (ALUSrc_o),
  .RegWrite_o   (RegWrite_o),
  .RegDst_o     (RegDst_o),
  .Branch_o     (Branch_o),
  .Jump_o       (Jump_o),
  .MemRead_o    (MemRead_o),
  .MemWrite_o   (MemWrite_o),
  .MemtoReg_o   (MemtoReg_o),
  .BranchType_o (BranchType_o),      
  .Jal_o        (Jal)
);

ALU_Ctrl AC (
      .funct_i(instr[5:0]),
      .ALUOp_i(ALU_op_o),
      .ALUCtrl_o(ALUCtrl_o),
      .FURslt_o(FURslt_o),
      .lR_o(lR_o)
);

Sign_Extend SE (
      .data_i(instr[15:0]),
      .data_o(ex_instr)
);

MUX_2to1 #(
      .size(32)
  ) ALU_Src (
      .data0_i (read_data2),
      .data1_i (ex_instr),
      .select_i(ALUSrc_o),
      .data_o  (ALU_in)
);

ALU ALU (
      .src1_i(read_data1),
      .src2_i(ALU_in),
      .ctrl_i(ALUCtrl_o),
      .result_o(result_o),
      .zero_o(zero_o),
      .overflow(overflow)
);

wire isShiftVar = isR && (funct==6'b000110 || funct==6'b001000);
wire [4:0] shamt_src = isShiftVar ? read_data1[4:0] : instr[10:6];

Shifter shifter(
  .result (shift_out),
  .lR     (lR_o),        
  .shamt  (shamt_src),
  .Src    (read_data2)
);

wire isShift=isR && (funct == 6'b000010 || // sll
            funct == 6'b000100 || // srl
            funct == 6'b000110 || // sllv
            funct == 6'b001000
);  // srlv 

wire isLUI = 1'b0;
wire [1:0] FUR_sel = isShift ? 2'b01 :
                     isLUI   ? 2'b10 :
                               2'b00;

MUX_3to1 #(.size(32)) RDdata_Source (
    .data0_i (result_o),                 // 00: ALU
    .data1_i (shift_out),                // 01: Shifter
    .data2_i ({16'b0, instr[15:0]}),     // 10: ZeroExtend
    .select_i(FUR_sel),
    .data_o  (mux3to1out)
);

Data_Memory Data_Memory(
	.clk_i(clk_i), 
	.addr_i(result_o), 
	.data_i(read_data2), 
	.MemRead_i(MemRead_o), 
	.MemWrite_i(MemWrite_o), 
	.data_o(dm_out)
);

wire [31:0] wb_pre;

MUX_2to1 #(
      .size(32)
) Mux_Write (
      .data0_i(mux3to1out), 
      .data1_i(dm_out),
      .select_i(MemtoReg_o),
      .data_o(wb_pre) 
);

assign write_data = is_jal ? add_o : wb_pre;  
endmodule