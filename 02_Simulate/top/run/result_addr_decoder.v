module result_addr_decoder (
        addr_0
      , addr_1
      , addr_2
      , addr_3
      , addr_4
      , wen_0
      , wen_1
      , wen_2
      , wen_3
      , wen_4
      , data_0
      , data_1
      , data_2
      , data_3
      , data_4
      , addr_sel
      , addr_out
      , wen_out
      , data_out
        );

parameter ADDR_WIDTH = 12;
parameter DATA_WIDTH = 32;
// addr 14 bits
input [ADDR_WIDTH+1 : 0] addr_0, addr_1, addr_2, addr_3, addr_4;
input [2:0] addr_sel;
input wen_0, wen_1, wen_2, wen_3, wen_4;
input [DATA_WIDTH-1 : 0] data_0, data_1, data_2, data_3, data_4;

output [ADDR_WIDTH+1 : 0] addr_out; // 14 bits addr
output wen_out;
output [DATA_WIDTH-1 : 0] data_out;

reg [ADDR_WIDTH+1 : 0] addr_out;
reg wen_out;
reg [DATA_WIDTH-1 : 0] data_out;

always @(addr_0 or addr_1 or addr_2 or addr_3 or addr_4 or addr_sel or wen_0 or wen_1 or wen_2 or wen_3 or wen_4 or data_0 or data_1 or data_2 or data_3 or data_4) begin
    case (addr_sel)
        3'b000: begin
            addr_out <= addr_0;
            wen_out <= wen_0;
            data_out <= data_0;
        end
        3'b001: begin
            addr_out <= addr_1;
            wen_out <= wen_1;
            data_out <= data_1;
        end
        3'b010: begin
            addr_out <= addr_2;
            wen_out <= wen_2;
            data_out <= data_2;
        end
        3'b011: begin
            addr_out <= addr_3;
            wen_out <= wen_3;
            data_out <= data_3;
        end
        3'b100: begin
            addr_out <= addr_4;
            wen_out <= wen_4;
            data_out <= data_4;
        end
    endcase        
end       
endmodule
