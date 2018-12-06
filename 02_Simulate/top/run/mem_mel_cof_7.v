module mem_mel_cof_7 (clk, addr, cen, wen, data, q);
parameter DATA_WIDTH =  32;
input clk;
input [11:0] addr;// Note
input cen;
input wen;
input [DATA_WIDTH-1:0]data;
output [DATA_WIDTH-1:0] q;
reg    [DATA_WIDTH-1:0] q;
always@(posedge clk) begin
    case(addr)
        default: q <= 0;
    endcase
end
endmodule
