module memory (clk
              , cen
              , wen
              , addr
              , data
              , q
              );
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;
parameter SIZE = 4096;

input clk, cen, wen;
input [ADDR_WIDTH-1 : 0] addr;/////DAT////
input [DATA_WIDTH-1 : 0] data;

output [DATA_WIDTH-1 : 0] q;

reg [DATA_WIDTH-1 : 0] q;
reg  [DATA_WIDTH-1 : 0] mem [SIZE-1 : 0];

always @(posedge clk)  begin
    if (~cen) begin
        q <= 32'b0;
    end
    else if (~wen) begin
        q <= mem [addr];         // wen = 0,READ mode
    end
    else if (wen) begin
        mem [addr] <= data;      // wen = 1,WRITE mode
    end
    else begin
        q <= q;
    end
end

endmodule
 
