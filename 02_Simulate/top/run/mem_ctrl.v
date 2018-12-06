module mem_ctrl (
        mem_sel
      , read_en
      , write_en
      , read_addr
      , write_addr
      , q_1
      , q_2
      , state_en_1
      , state_en_2
      , cen_1
      , cen_2
      , wen_1
      , wen_2
      , addr_1
      , addr_2 
      , data_out
      );

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;

input mem_sel, read_en, write_en, state_en_1, state_en_2;
input [ADDR_WIDTH-1 : 0] read_addr, write_addr;
input [DATA_WIDTH-1 : 0] q_1, q_2;

output wen_1, wen_2, cen_1, cen_2;
output [ADDR_WIDTH-1 : 0] addr_1, addr_2;
output [DATA_WIDTH-1 : 0] data_out;

wire cen_1, cen_2;

//Rule: mem_sel = 1 : memory 1 is reading and memory 2 is writing

assign wen_1 = mem_sel ? read_en : write_en;
assign wen_2 = mem_sel ? write_en : read_en;
assign addr_1 = mem_sel ? read_addr : write_addr;
assign addr_2 = mem_sel ? write_addr : read_addr;
assign data_out = mem_sel ? q_1 : q_2;
assign {cen_1, cen_2} = 2'b11;

/*
always@(state_en_1 or state_en_2 or mem_sel) begin
    case ({state_en_1,state_en_2})
        2'b00: begin
            cen_1 <= 1'b0;
            cen_2 <= 1'b0;
        end
        2'b01: begin
            cen_1 <= mem_sel;
            cen_2 <= ~mem_sel;
        end
        2'b10: begin
            cen_1 <= ~mem_sel;
            cen_2 <= mem_sel;
        end
        2'b11: begin
            cen_1 <= 1'b1;
            cen_2 <= 1'b1;
        end
    endcase    
end
*/

endmodule
