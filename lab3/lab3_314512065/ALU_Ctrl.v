// student ID:314512065
module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o,
        FURslt_o,
        lR_o
);
          
// I/O ports 
input      [6-1:0] funct_i;
input      [2-1:0] ALUOp_i;

output  reg [4-1:0] ALUCtrl_o;
output  reg [2-1:0] FURslt_o; 
output  reg lR_o;
     
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
                FURslt_o=2'b00;
        end else if(ALUOp_i==2'b01 || (ALUOp_i==2'b10 && funct_i==6'b100001)) begin
                ALUCtrl_o=4'b0110;      //sub
                FURslt_o=2'b00;
        end else if(ALUOp_i==2'b10 && funct_i==6'b100110) begin
                ALUCtrl_o=4'b0001;      //and
                FURslt_o=2'b00;
        end else if(ALUOp_i==2'b10 && funct_i==6'b100101) begin
                ALUCtrl_o=4'b0000;      //or
                FURslt_o=2'b00;
        end else if(ALUOp_i==2'b10 && funct_i==6'b101000) begin
                ALUCtrl_o=4'b0111;      //slt
                FURslt_o=2'b00;
        end else if(ALUOp_i==2'b10 && funct_i==6'b101011) begin
                ALUCtrl_o=4'b1101;      //nor
                FURslt_o=2'b00;
        end else if(ALUOp_i==2'b10 && funct_i==6'b000010) begin
                ALUCtrl_o=4'b0001;      //sll
                FURslt_o=2'b01;
        end else if(ALUOp_i==2'b10 && funct_i==6'b000100) begin
                ALUCtrl_o=4'b0000;      //srl
                FURslt_o=2'b01;
        end else if(ALUOp_i==2'b10 && funct_i==6'b000110) begin
                ALUCtrl_o=4'b1000;      //sllv
                FURslt_o=2'b01;
        end else if(ALUOp_i==2'b10 && funct_i==6'b001000) begin
                ALUCtrl_o=4'b1010 ;      //srlv
                FURslt_o=2'b01;
        end else begin
                ALUCtrl_o=4'b0000;
                FURslt_o=2'b00;
        end
        lR_o = (funct_i == 6'b000100 || funct_i == 6'b001000) ? 1'b1 : 1'b0; 
end  

endmodule