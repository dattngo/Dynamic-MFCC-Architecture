module one_mem_data_ctrl (
          sel
        , wen_0
        , wen_1
        , addr_0
        , addr_1
        , wen
        , addr
           );

parameter ADDR_WIDTH = 12;

input sel, wen_0, wen_1;
input [ADDR_WIDTH-1 : 0] addr_0, addr_1;

output wen;
output [ADDR_WIDTH-1 : 0] addr;

assign wen = sel ? wen_1 : wen_0;
assign addr = sel ? addr_1 : addr_0;

endmodule
