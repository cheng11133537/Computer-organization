//Student ID: 314512065
`timescale 1ns/1ps

module MUX_2to1(
    input        src1,    
    input        src2,    
    input        select,  
    output reg   result   
);

    always @(src1,src2,select) begin
        if (select == 0) begin 
            result <= src1;        
        end 
		else begin            
            result <= src2;        
        end
    end

endmodule