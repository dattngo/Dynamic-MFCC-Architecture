module change_addr_15bits (clk, rst_n
                    , change_addr_value
                    , change_addr_sel
                    , change_addr_out);

parameter ADDR_WIDTH = 15;

input clk, rst_n;
input [1:0] change_addr_sel;
input [ADDR_WIDTH-1 : 0] change_addr_value;
output [ADDR_WIDTH-1 : 0] change_addr_out;

wire [ADDR_WIDTH : 0] sum;
reg [ADDR_WIDTH-1 : 0] a, b;
reg [ADDR_WIDTH-1 : 0] a_in;
reg [ADDR_WIDTH-1 : 0] b_in;
//reg [ADDR_WIDTH-1 : 0] change_addr_out;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      a <= 15'd0;
      b <= 15'd0;
    end
    else begin
      a <= a_in;
      b <= b_in;
    end
end

always@(change_addr_sel or change_addr_value or change_addr_out) begin
     case (change_addr_sel)
     2'b00: begin //reset
     a_in <= 15'd0; 
     b_in <= 15'd0;
     end
     2'b01: begin 
     a_in <= change_addr_out; 
     b_in <= 15'd1;
     end
     2'b10: begin //add value
     a_in <= change_addr_out; 
     b_in <= change_addr_value;
     end
     2'b11: begin //no change
     a_in <= change_addr_out; 
     b_in <= 15'd0;
     end
     endcase
end

cla_15bit cla_15bit_01 (
         .clk (clk),
         .rst_n (rst_n),
         .input_1 (a),
         .input_2 (b),
         .c_in (1'b0),
         .sum (sum));
assign change_addr_out = sum [ADDR_WIDTH-1 : 0];
//assign a_in = change_addr_out;

endmodule


