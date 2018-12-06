
module counter (clk, rst_n 
                , counter_en
                , counter_value
  //            , counter_out
                , counter_over
                );

parameter COUNTER_VALUE_WIDTH = 4;

input clk, rst_n, counter_en;
input [COUNTER_VALUE_WIDTH-1 : 0] counter_value;

//output [COUNTER_VALUE_WIDTH-1 : 0] counter_out;
output counter_over;

reg [COUNTER_VALUE_WIDTH-1 : 0] counter_reg, dff_out;

wire [COUNTER_VALUE_WIDTH-1 : 0] dff_in, counter_out;

assign dff_in = counter_out + 1;
assign counter_out = ~ counter_over ? dff_out : 4'd0;
assign counter_over = (dff_out == counter_value) ? 1'b1 : 1'b0;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n | ~counter_en) begin 
        dff_out <= 4'b0;
    end
    else begin
        dff_out <= dff_in;
    end
end

endmodule

