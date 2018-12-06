module amplitude_state_ctrl (clk,rst_n
                           , ampli_state_en
                           , counter_over
                           , num_wait
                           , change_addr_sel
                           , change_addr_value
                           , add_en
                           , mul_en
                           , write_ampli_data_en
                           , write_ampli_addr_en
                           , ena_max_min_fp_clk
                           , counter_en
                           , counter_loop_en
                           , counter_loop_over);

//parameters for setting
parameter ADDR_WIDTH = 12;
parameter COUNTER_VALUE_WIDTH = 4;
parameter LOOPS_READ = 4'd2;
parameter LOOPS_ADD = 4'd10;
parameter LOOPS_MUL = 4'd10;
parameter LOOPS_COMPARE = 4'd10;
parameter LOOPS_WAIT = 4'd5;
parameter LOOPS_WRITE = 4'd5;

// parameters for states
parameter RESET = 4'd0;
parameter START = 4'd1;
parameter BRANCH = 4'd2;
parameter WAIT = 4'd3;
parameter CAL_ADDR = 4'd4;
parameter READ = 4'd5;
parameter COMPARE = 4'd6;
parameter MUL = 4'd7;
parameter ADD = 4'd8;
parameter WRITE = 4'd9;
parameter PRE_CALC = 4'd10;

//IO
input clk, rst_n, ampli_state_en, counter_over;
input counter_loop_over;

output  add_en, mul_en, write_ampli_data_en, write_ampli_addr_en, ena_max_min_fp_clk, counter_en, counter_loop_en;
output [3:0] num_wait;
output [1:0] change_addr_sel;
output [ADDR_WIDTH-1 : 0] change_addr_value;


reg [3:0] present_state, next_state;
reg add_en, mul_en, write_ampli_addr_en, write_ampli_data_en, ena_max_min_fp_clk, counter_en, counter_loop_en;
reg [3:0] num_wait; 
reg [ADDR_WIDTH-1 : 0] counter_loop_value;
reg [1:0] change_addr_sel;
reg [ADDR_WIDTH-1 : 0] change_addr_value;



always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         present_state <= RESET;
    end
    else begin
         present_state <= next_state;
    end
end
//state machine for next_state

always@(present_state or ampli_state_en or counter_over or counter_loop_over)
    case (present_state)
     RESET: begin
     if (rst_n & ampli_state_en) begin
     next_state <= START;
     end
     else begin
     next_state <= RESET;
     end
     end
     START: begin
             next_state <= BRANCH;
     end
     BRANCH: begin
          if (counter_loop_over) begin
          next_state <= WAIT;
          end
          else begin
          next_state <= CAL_ADDR;
          end   
     end

     PRE_CALC: begin
         next_state <= CAL_ADDR;
     end

     CAL_ADDR: begin
             next_state <= READ;
     end
     READ: begin
             next_state <= COMPARE;
     end
     COMPARE: begin
             if (counter_over)
             next_state <= MUL;
             else next_state <= COMPARE;
     end
     MUL: begin
             if (counter_over)
             next_state <= ADD;
             else next_state <= MUL;
     end 
     ADD: begin
             if (counter_over)
             next_state <= WRITE;
             else next_state <= ADD;
     end
     WRITE: begin
          next_state <= BRANCH;
     end
     WAIT: begin
             if (ampli_state_en)
             next_state <= PRE_CALC;
             else next_state <= WAIT;
     end
endcase

///////// State machine //////

always@(present_state)
    case (present_state)
    RESET: begin
     add_en <= 1'b0;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b0; 
     counter_loop_en <= 1'b0;
     num_wait <= 5'd0;
     change_addr_sel <= 2'b11;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
     end
    
    START: begin
     add_en <= 1'b0;
     mul_en <= 1'b0; 
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b0; 
     counter_loop_en <= 1'b0;
     num_wait <= 5'd0;                              
     change_addr_sel <= 2'b00;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
    end

   BRANCH: begin
     add_en <= 1'b0;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= 5'd1; 
     change_addr_sel <= 2'b11;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
    end

   PRE_CALC: begin
     add_en <= 1'b0;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= 5'd1; 
     change_addr_sel <= 2'b00;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
    end

   CAL_ADDR: begin
     add_en <= 1'b1;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b0; 
     counter_loop_en <= 1'b1;
     num_wait <= 5'd0; 
     change_addr_sel <= 2'b01;
     change_addr_value <= 5'd1;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
    end

   READ: begin
     add_en <= 1'b0;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b0; 
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_READ; 
     change_addr_sel <= 2'b11;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
   end
   COMPARE: begin
     add_en <= 1'b0;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b1;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_COMPARE; 
     change_addr_sel <= 2'b11;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
    end
   MUL: begin
     add_en <= 1'b0;
     mul_en <= 1'b1;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b1;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_MUL; 
     change_addr_sel <= 2'b11;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
    end
   ADD: begin
     add_en <= 1'b1;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b1;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_ADD; 
     change_addr_sel <= 2'b11;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b1; ///////////////////
    end
   WRITE : begin
     add_en <= 1'b0;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b0;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_WRITE; 
     change_addr_sel <= 2'b11;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b1;
     write_ampli_addr_en <= 1'b1;
    end
   WAIT: begin
     add_en <= 1'b0;
     mul_en <= 1'b0;
     ena_max_min_fp_clk <= 1'b0;
     counter_en <= 1'b0;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_WAIT; 
     change_addr_sel <= 2'b11;
     change_addr_value <= 5'd0;
     write_ampli_data_en <= 1'b0;
     write_ampli_addr_en <= 1'b0;
    end   

    endcase
      
endmodule




