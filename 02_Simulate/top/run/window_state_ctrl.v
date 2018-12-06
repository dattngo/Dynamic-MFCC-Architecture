module window_state_ctrl ( clk, rst_n
                          , window_state_en
                          , counter_over
                          , counter_sample_over
                          , counter_addr_over
                          , mul_en
                          , counter_en
                          , counter_sample_en
                          , counter_addr_en
                          , counter_value
                          , write_win_en
                          , fill_zero
                           );

parameter DATA_WIDTH = 32;
parameter RESET = 4'd0;
parameter BRANCH = 4'd1;
parameter CAL_ADDR = 4'd2;
parameter READ = 4'd3;
parameter MUL = 4'd4;
parameter WRITE = 4'd5;
parameter BRANCH_0 = 4'd6;
parameter CAL_ADDR_0 = 4'd7;
parameter WRITE_0 = 4'd8;
parameter WAIT = 4'd9;
parameter COUNTER_VALUE_WIDTH = 4;
parameter LOOPS_MUL = 4'd10;
parameter LOOPS_WRITE = 4'd2;

input clk, rst_n, window_state_en, counter_over, counter_sample_over;
input counter_addr_over;

output mul_en, counter_en, counter_sample_en, write_win_en;
output counter_addr_en;
output [COUNTER_VALUE_WIDTH-1 : 0] counter_value;
output fill_zero;

reg [3:0] present_state, next_state;
reg mul_en, counter_en, counter_sample_en, write_win_en, counter_addr_en;
reg  [COUNTER_VALUE_WIDTH-1 : 0] counter_value;
reg fill_zero;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
    present_state <= RESET;
    end
    else begin
    present_state <= next_state;
    end
end

//state machine for next state
always@(present_state or window_state_en or counter_over or counter_sample_over)
    case (present_state)
     RESET: begin
         if (window_state_en) begin
         next_state <= BRANCH;
         end
         else begin
         next_state <= RESET;
         end
     end
     BRANCH: begin
      if (counter_sample_over) begin
      next_state <= BRANCH_0;
      end
      else begin
      next_state <= CAL_ADDR;
      end
      end

     BRANCH_0: begin
      if (counter_addr_over) begin
      next_state <= WAIT;
      end
      else begin
      next_state <= CAL_ADDR_0;
      end
      end

     CAL_ADDR_0: begin
      next_state <= WRITE_0;
     end

     WRITE_0: begin
      next_state <= BRANCH_0;
     end

     CAL_ADDR: begin
      next_state <= READ;
     end
     READ: begin
      next_state <= MUL;
     end
     MUL: begin
      if (counter_over) begin
      next_state <= WRITE;
      end
      else begin
      next_state <= MUL;
      end
     end
     WRITE: begin
      next_state <= BRANCH;
      end
     WAIT: begin
      if (window_state_en) begin
      next_state <= CAL_ADDR;
      end
      else begin
      next_state <= WAIT;
      end
     end
     
   endcase

always@(present_state)
    case (present_state)
     RESET: begin
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_sample_en <= 1'b0;
     counter_value <= 4'd0;
     write_win_en <= 1'b0;
     counter_addr_en <= 1'b0;
     fill_zero <= 1'b0;
     end
     
     READ: begin
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_sample_en <= 1'b0;
     counter_value <= 4'd0;
     write_win_en <= 1'b0;
     counter_addr_en <= 1'b0;
     fill_zero <= 1'b0;
     end
   
     MUL: begin
     mul_en <= 1'b1;
     counter_en <= 1'b1;
     counter_sample_en <= 1'b0;
     counter_value <= LOOPS_MUL;
     write_win_en <= 1'b0; 
     counter_addr_en <= 1'b0;
     fill_zero <= 1'b0;
     end
     

     WRITE: begin
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_sample_en <= 1'b0;
     counter_value <= 4'd0;
     write_win_en <= 1'b1; 
     counter_addr_en <= 1'b0;
     fill_zero <= 1'b0;
     end

     CAL_ADDR: begin
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_sample_en <= 1'b1;
     counter_value <= 4'd0;
     write_win_en <= 1'b0; 
     counter_addr_en <= 1'b1;
     fill_zero <= 1'b0;
     end

     BRANCH_0: begin
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_sample_en <= 1'b0;
     counter_value <= 4'd0;
     write_win_en <= 1'b0; 
     counter_addr_en <= 1'b0;
     fill_zero <= 1'b1;
     end

     CAL_ADDR_0: begin
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_sample_en <= 1'b0;
     counter_value <= 4'd0;
     write_win_en <= 1'b0; 
     counter_addr_en <= 1'b1;
     fill_zero <= 1'b1;
     end

     WRITE_0: begin
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_sample_en <= 1'b0;
     counter_value <= LOOPS_WRITE;
     write_win_en <= 1'b1; 
     counter_addr_en <= 1'b0;
     fill_zero <= 1'b1;
     end

     WAIT: begin
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_sample_en <= 1'b0;
     counter_value <= LOOPS_WRITE;
     write_win_en <= 1'b0; 
     counter_addr_en <= 1'b0;
     fill_zero <= 1'b1;
     end
     endcase

endmodule

