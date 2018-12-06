module cla_8bit(clk,rst_n,input_1,input_2,c_in,sum);

//parameter define
parameter ADDR_WIDTH = 8;

//input define
input clk;
input rst_n;
input [ADDR_WIDTH-1:0] input_1;
input [ADDR_WIDTH-1:0] input_2;
input c_in;

//output define
output [ADDR_WIDTH:0] sum;

wire [ADDR_WIDTH-1:0] a;
wire [ADDR_WIDTH-1:0] b;

/*
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        a <= 0;
        b <= 0;
    end
    else begin
        a <= input_1;
        b <= input_2;
    end


end
*/

assign a = input_1;
assign b = input_2;

//internal signal
wire [ADDR_WIDTH-1:0] p;
wire [ADDR_WIDTH-1:0] g;
wire [ADDR_WIDTH:0] c;

assign p[ADDR_WIDTH-1:0] = a[ADDR_WIDTH-1:0] ^ b[ADDR_WIDTH-1:0];
assign g[ADDR_WIDTH-1:0] = a[ADDR_WIDTH-1:0] & b[ADDR_WIDTH-1:0];
assign c[0] = c_in;
assign c[1] = g[0] | (p[0] & c[0]);

assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);

assign c[3] = g[2] | (p[2] &  g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

assign c[4] = g[3] | (p[3] &  g[2]) | (p[3] & p[2] &  g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

assign c[5] = g[4] | (p[4] &  g[3]) | (p[4] & p[3] &  g[2]) | (p[4] & p[3] & p[2] &  g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]) | (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

assign c[6] = g[5] | (p[5] &  g[4]) | (p[5] & p[4] &  g[3]) | (p[5] & p[4] & p[3] &  g[2]) | (p[5] & p[4] & p[3] & p[2] &  g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

assign c[7] = g[6] | (p[6] &  g[5]) | (p[6] & p[5] &  g[4]) | (p[6] & p[5] & p[4] &  g[3]) | (p[6] & p[5] & p[4] & p[3] &  g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] &  g[1]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

assign c[8] = g[7] | (p[7] &  g[6]) | (p[7] & p[6] &  g[5]) | (p[7] & p[6] & p[5] &  g[4]) | (p[7] & p[6] & p[5] & p[4] &  g[3]) | (p[7] & p[6] & p[5] & p[4] & p[3] &  g[2]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] &  g[1]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);


assign sum[ADDR_WIDTH:0] = {1'b0,p[ADDR_WIDTH-1:0]} ^ c[ADDR_WIDTH:0];

endmodule





















