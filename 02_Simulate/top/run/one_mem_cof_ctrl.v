module one_mem_cof_ctrl (
           system_sel
         , cen_in
         , read_wen
         , system_wen
         , read_addr
         , system_addr
         , write_data_in
         , cen_out
         , wen_out
         , addr_out
         , write_data_out
         );

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;

input system_sel, cen_in, read_wen, system_wen;
input [ADDR_WIDTH-1 : 0] read_addr, system_addr;
input [DATA_WIDTH-1 : 0] write_data_in;

output cen_out, wen_out;
output [ADDR_WIDTH-1 : 0] addr_out;
output [DATA_WIDTH-1 : 0] write_data_out;

assign cen_out = cen_in;
assign wen_out = system_sel ? read_wen : system_wen;
assign write_data_out = write_data_in;
assign addr_out = system_sel ? read_addr : system_addr;

endmodule
