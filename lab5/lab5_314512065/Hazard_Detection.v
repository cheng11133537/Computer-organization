// student ID:314512065
module Hazard_Detection(
    memread,
    ifid_regs,
    ifid_regt,
    idex_regt,
    branch,
    pcwrite,
    ifid_write,
    ifid_flush,
    idex_flush,
    exmem_flush
);

// TO DO
input memread;
input [4:0] ifid_regs;
input [4:0] ifid_regt;
input [4:0]idex_regt;
input branch;
output pcwrite;
output ifid_write;
output ifid_flush;
output idex_flush;
output exmem_flush;

reg pcwrite,ifid_write,ifid_flush,idex_flush,exmem_flush;

always @(*) begin
    if(branch) begin
        pcwrite<=1;
        ifid_write<=0;
        ifid_flush<=1;
        idex_flush<=1;
        exmem_flush<=1;
    end else begin 
        if(memread & ((idex_regt==ifid_regs) | (idex_regt==ifid_regt))) begin
            pcwrite <= 0;
            ifid_write <= 0;
            ifid_flush <= 0;
            idex_flush <= 1;
            exmem_flush <= 0;
        end else begin
            pcwrite  <= 1;
            ifid_write <= 1;
            ifid_flush <= 0;
            idex_flush <= 0;
            exmem_flush <= 0;
        end
    end
end

endmodule