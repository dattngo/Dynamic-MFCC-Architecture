
module counter_cep_in_delta_7bit (clk, rst_n 
                , counter_loop_en
                , counter_loop_value
                , counter_loop_over
                , counter_loop_out
                );

parameter COUNTER_VALUE_WIDTH = 7;

input clk, rst_n, counter_loop_en;
input [COUNTER_VALUE_WIDTH-1 : 0] counter_loop_value;

output [COUNTER_VALUE_WIDTH-1 : 0] counter_loop_out;
output counter_loop_over;

//reg counter_loop_over;
reg [COUNTER_VALUE_WIDTH-1 : 0] dff_out;

wire [COUNTER_VALUE_WIDTH-1 : 0] dff_in,add_out, counter_loop_reg;
//wire counter_loop_sel;

assign add_out = counter_loop_reg + 1;
assign dff_in = counter_loop_en ? add_out : dff_out; 
assign counter_loop_reg = ~ counter_loop_over ? dff_out : 7'b1111111;
//assign counter_loop_sel = (dff_out == counter_loop_value) ? 1'b1 : 1'b0;
assign counter_loop_out = dff_out;
assign counter_loop_over = (dff_out == counter_loop_value) ? 1'b1 : 1'b0;


always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin 
        dff_out <= 7'd0;
    end
    else begin
        dff_out <= dff_in;
    end
end

endmodule

