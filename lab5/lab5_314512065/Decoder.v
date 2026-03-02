// student ID:314512065
module Decoder( 
  instr_op_i,
  funct_i,
  ALU_op_o,
  ALUSrc_o,
  RegWrite_o,
  RegDst_o,
  Branch_o,
  MemRead_o,
  MemWrite_o,
  MemtoReg_o, 
);

input  [5:0] instr_op_i;
input  [5:0] funct_i;

output reg [1:0] ALU_op_o;
output reg       ALUSrc_o, RegWrite_o, RegDst_o, Branch_o;
output reg       MemRead_o, MemWrite_o, MemtoReg_o;

localparam Rtype   = 6'b000000;
localparam addi    = 6'b001001;
localparam lw      = 6'b101100;
localparam sw      = 6'b100100;
localparam beq     = 6'b000110;
localparam bne     = 6'b000101;

always @(*) begin
  ALU_op_o     = 2'b00;
  ALUSrc_o     = 1'b0;
  RegWrite_o   = 1'b0;
  RegDst_o     = 1'b0;
  Branch_o     = 1'b0;
  MemRead_o    = 1'b0;
  MemWrite_o   = 1'b0;
  MemtoReg_o   = 1'b0;

  case (instr_op_i)
    Rtype: begin
      begin
        // 一般 R-type
        RegWrite_o = 1'b1;
        RegDst_o   = 1'b1;
        ALUSrc_o   = 1'b0;
        ALU_op_o   = 2'b10;
      end
    end

    addi: begin
      RegWrite_o = 1'b1;
      RegDst_o   = 1'b0;  // 寫 rt
      ALUSrc_o   = 1'b1;
      ALU_op_o   = 2'b00;
    end

    lw: begin
      RegWrite_o = 1'b1;
      RegDst_o   = 1'b0;
      ALUSrc_o   = 1'b1;
      MemRead_o  = 1'b1;
      MemtoReg_o = 1'b1;
      ALU_op_o   = 2'b00;
    end

    sw: begin
      RegWrite_o = 1'b0;
      ALUSrc_o   = 1'b1;
      MemWrite_o = 1'b1;
      ALU_op_o   = 2'b00;
    end

    beq: begin
      Branch_o     = 1'b1;
      ALU_op_o     = 2'b01;
    end

    bne: begin
      Branch_o     = 1'b1;
      ALU_op_o     = 2'b01;
    end
  endcase
end
endmodule