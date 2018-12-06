module trigger (clk, rst_n
                , trigger_in
                , trigger_out
                 );

parameter TRIGGER_NUM = 7;

input clk, rst_n;
input [TRIGGER_NUM-1 : 0] trigger_in;

output [TRIGGER_NUM-1 : 0] trigger_out;

wire [TRIGGER_NUM-1 : 0] trigger_w;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        trigger_w <= 0;
    end
    else begin
        trigger_w <= trigger_in;  
    end        
end

assign trigger_out <= trigger_w ^ trigger_in;

endmodule        

