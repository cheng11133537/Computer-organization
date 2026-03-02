// student ID:314512065
module MUX_3to1(
               data0_i,
               data1_i,
               data2_i,
               select_i,
               data_o
);

parameter size = 0;
// I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [2-1:0]    select_i;

output reg [size-1:0] data_o; 

// Internal Signals


// Main function
always@(*)begin
    if(select_i==2'b00) begin
        data_o=data0_i;
    end else if(select_i==2'b01) begin
        data_o=data1_i;
    end else if(select_i==2'b10) begin
        data_o=data2_i;
    end
end
endmodule      
          
          
          
          