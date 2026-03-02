// student ID:314512065
module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o,
);
          
// I/O ports 
input      [6-1:0] funct_i;
input      [2-1:0] ALUOp_i;

output  reg [4-1:0] ALUCtrl_o;
// Internal Signals
// add = 6'b100011
// sub = 6'b100001
// and = 6'b100110
// or  = 6'b100101
// nor = 6'b101011
// sll = 6'b000010
// slt = 6'b101000
// srl = 6'b000100
// jr  = 6'b001001
// sllv= 6'b000110
// srlv= 6'b001000

// Main function
always @(*) begin
        if(ALUOp_i==2'b00 || (ALUOp_i==2'b10 && funct_i==6'b100011)) begin
                ALUCtrl_o=4'b0010;       //add
        end else if(ALUOp_i==2'b01 || (ALUOp_i==2'b10 && funct_i==6'b100001)) begin
                ALUCtrl_o=4'b0110;      //sub
        end else if(ALUOp_i==2'b10 && funct_i==6'b100110) begin
                ALUCtrl_o=4'b0001;      //and
        end else if(ALUOp_i==2'b10 && funct_i==6'b100101) begin
                ALUCtrl_o=4'b0000;      //or
        end else if(ALUOp_i==2'b10 && funct_i==6'b101000) begin
                ALUCtrl_o=4'b0111;      //slt
        end else if(ALUOp_i==2'b10 && funct_i==6'b101011) begin
                ALUCtrl_o=4'b1101;      //nor
        end else if(ALUOp_i==2'b10 && funct_i==6'b000010) begin
                ALUCtrl_o=4'b0001;      //sll
        end else if(ALUOp_i==2'b10 && funct_i==6'b000100) begin
                ALUCtrl_o=4'b0000;      //srl
        end else if(ALUOp_i==2'b10 && funct_i==6'b000110) begin
                ALUCtrl_o=4'b1000;      //sllv
        end else if(ALUOp_i==2'b10 && funct_i==6'b001000) begin
                ALUCtrl_o=4'b1010 ;      //srlv
        end else begin
                ALUCtrl_o=4'b0000;
        end
end  

endmodule