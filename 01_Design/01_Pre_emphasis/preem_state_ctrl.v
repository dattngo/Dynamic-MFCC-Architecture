module preem_state_ctrl (clk,rst_n
                        , preem_state_en
                        , counter_over
                        , com_2_ovl
                        , num_wait
                        , sel
                        , change_addr_sel
                        , change_addr_value
                        , add_en
                        , mul_en
                        , counter_en
                        , counter_loop_en
                        , counter_loop_over
                        , addr_preem_en
                        , write_preem_en
                        , energy_log_en
                        , sqr_en
                        , sel_log
                        , write_energy_log_en
                        , frame_count_en
                        , log_add_en
                        );

//parameters for setting
parameter ADDR_WIDTH = 12;
parameter OVL_BITS_WIDTH = 12;
parameter LOOPS_READ = 4'd2;
parameter LOOPS_ADD = 4'd10;
parameter LOOPS_MUL = 4'd10; // Note: It can't be decreased because it takes 10 cc for both add and mul in state MUL_ADD
parameter LOOPS_WAIT_0 = 4'd5;
parameter LOOPS_WAIT = 4'd5;
parameter LOOPS_WRITE = 4'd5;
parameter LOOPS_CAL = 4'd5;
parameter LOOPS_LOG = 4'd15;

// parameters for states
parameter RESET = 5'd0;
parameter START = 5'd1;
parameter READ_0 = 5'd2;
parameter SQR_0 = 5'd3;
parameter ADD_0 = 5'd4;
parameter WRITE_0 = 5'd5;
parameter MUL = 5'd6;
parameter BRANCH = 5'd7;
parameter LOG = 5'd8;
parameter WRITE_LOG = 5'd9;
parameter WAIT_M = 5'd10;
parameter CAL_ADDR = 5'd11;
parameter READ_M = 5'd12;
parameter MUL_ADD = 5'd13;
parameter INC_LOOP = 5'd14;
parameter READ_N = 5'd15;
parameter SQR_N = 5'd16;
parameter ADD_N = 5'd17;
parameter WRITE_N = 5'd18;
parameter WAIT = 5'd19;
parameter END = 5'd20;

//IO
input clk, rst_n, preem_state_en, counter_over;
input counter_loop_over;
input [OVL_BITS_WIDTH-1:0] com_2_ovl;

output sel, add_en, mul_en, counter_en, counter_loop_en, write_preem_en, addr_preem_en;
output energy_log_en, sqr_en, write_energy_log_en, frame_count_en, log_add_en;
output [1:0] change_addr_sel, sel_log;
output [3:0] num_wait;
output [ADDR_WIDTH-1 : 0] change_addr_value; 

reg [4:0] present_state, next_state;
reg add_en, mul_en, counter_en, counter_loop_en, sel, write_preem_en, addr_preem_en;
reg energy_log_en, sqr_en, frame_count_en, write_energy_log_en, log_add_en;
reg [1:0] change_addr_sel, sel_log;
reg [3:0] num_wait; 
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

always@(present_state or preem_state_en or counter_over)
    case (present_state)
     RESET: begin
     if (preem_state_en) begin
     next_state <= START;
     end
     else begin
     next_state <= RESET;
     end
     end
     START: begin
             //if (counter_over)
             //next_state <= PRE_CAL;
             next_state <= READ_0;
             // else next_state <= START;
     end
     READ_0: begin
          if (counter_over) begin
          next_state <= SQR_0;
          end
          else begin
          next_state <= READ_0;
          end   
     end
     SQR_0: begin
          if (counter_over) begin
          next_state <= ADD_0;
          end
          else begin
          next_state <= SQR_0;
          end   
     end
     ADD_0: begin
             if (counter_over)
             next_state <= WRITE_0;
             else next_state <= ADD_0;
     end
     WRITE_0: begin
             next_state <= MUL;
     end
   /*  WAIT_0: begin
             if (counter_over)
             next_state <= MUL;
             else next_state <= WAIT_0;
     end */
     MUL: begin
             if (counter_over)
             next_state <= BRANCH;
             else next_state <= MUL;
     end
     BRANCH: begin
             if (counter_loop_over) begin
             next_state <= LOG;
             end
             else begin
             next_state <= INC_LOOP;
             end
     end
     LOG: begin
          if (counter_over) begin
          next_state <= WRITE_LOG;
          end
          else begin
          next_state <= LOG;
          end   
     end
     WRITE_LOG: begin
             next_state <= WAIT_M;
     end
     WAIT_M: begin
             if (preem_state_en) begin
             next_state <= CAL_ADDR;
             end
             else begin
             next_state <= WAIT_M;
             end
             end

     INC_LOOP: begin
             next_state <= READ_N;
             end

     CAL_ADDR: begin
             next_state <= READ_M;
     end
     READ_M: begin          
     if (counter_over) begin
          next_state <= MUL_ADD;
     end
     else begin
          next_state <= READ_M;
     end
     end
     MUL_ADD: begin
     if (counter_over) begin
          next_state <= INC_LOOP;
     end
     else begin
         next_state <= MUL_ADD;
     end
     end

     READ_N: begin            
     if (counter_over) begin
             next_state <= SQR_N;
     end
     else begin
             next_state <= READ_N;
     end
     end
     SQR_N: begin            
     if (counter_over) begin
             next_state <= ADD_N;
     end
     else begin
             next_state <= SQR_N;
     end
     end
     ADD_N: begin
             if (counter_over)
             next_state <= WRITE_N;
             else next_state <= ADD_N;
     end
     WRITE_N: begin
          next_state <= MUL;
     end
     WAIT: begin
             if (counter_over)
             next_state <= END;
             else next_state <= WAIT;
     end
     END: begin
             next_state <= next_state;
     end
endcase

//state machine for Output

//assign sel = ~ counter_loop_over;

always@(present_state)
    case (present_state)
    RESET: begin
     sel <= 1'b0;
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b0; 
     counter_loop_en <= 1'b0;
     num_wait <= 5'd0;
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
     end
    
    START: begin
     sel <= 1'b0;                               
     change_addr_sel <= 2'b01;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b0; 
     counter_loop_en <= 1'b1;
     num_wait <= 5'd0;                              
     change_addr_value <= 5'd1;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end

   READ_0: begin
     sel <= 1'b0;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= 5'd1; 
     change_addr_value <= 5'd1;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end

   SQR_0: begin
     sel <= 1'b0;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_MUL; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b1;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end

   ADD_0: begin
     sel <= 1'b0;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b1;
     mul_en <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_ADD; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b1;
    end

   WRITE_0: begin
     sel <= 1'b0;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b0; 
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_WRITE; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b1;
     write_preem_en <= 1'b1;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
   end
  /* WAIT_0: begin
     sel <= 1'b0;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_WAIT_0; 
     change_addr_value <= 5'd1;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b0;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end */
   MUL: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b1;
     counter_en <= 1'b1;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_MUL; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end

   BRANCH: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_loop_en <= 1'b0;
     num_wait <= 0; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end

   LOG: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b1;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_LOG; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b1;
     sel_log <= 2'b0;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end
   WRITE_LOG: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b1;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_WRITE; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b1;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end
   WAIT_M: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_loop_en <= 1'b0;
     num_wait <= 0; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end
   CAL_ADDR: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b10;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_CAL; 
     change_addr_value <= com_2_ovl;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b1; // Note: increase number of frame andreset the register off LOG_ADD_DATA_IN_2
     log_add_en <= 1'b0;
    end

   MUL_ADD: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b1;
     counter_en <= 1'b1;
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_MUL; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b1;
    end

   READ_M: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= 5'd1; 
     change_addr_value <= 5'd1;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b00;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end
  INC_LOOP: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b01;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b0;
     counter_loop_en <= 1'b1;
     num_wait <= 0; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end

/*  WAIT_N: begin
    sel <= 1'b1;               
    change_addr_sel <= 2'b11;
    add_en <= 1'b0;
    mul_en <= 1'b0;
    counter_en <= 1'b1; 
    counter_loop_en <= 1'b0;
    num_wait <= LOOPS_WAIT_N; 
    change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b0;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
   end
*/

   READ_N: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= 5'd1; 
     change_addr_value <= 5'd1;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b10;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end
   SQR_N: begin
     sel <= 1'b0;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b0;
     mul_en <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_MUL; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b1;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
    end
   ADD_N: begin
     sel <= 1'b1;               
     change_addr_sel <= 2'b11;
     add_en <= 1'b1;
     mul_en <= 1'b0;
     counter_en <= 1'b1; 
     counter_loop_en <= 1'b0;
     num_wait <= LOOPS_ADD; 
     change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b1;
    end
   WRITE_N: begin
    sel <= 1'b1;
    change_addr_sel <= 2'b11;
    add_en <= 1'b0;
    mul_en <= 1'b0;
    counter_en <= 1'b1; 
    counter_loop_en <= 1'b0;
    num_wait <= LOOPS_WRITE; 
    change_addr_value <= 5'd0;
     addr_preem_en <= 1'b1;
     write_preem_en <= 1'b1;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
   end
  WAIT: begin
    sel <= 1'b1;               
    change_addr_sel <= 2'b11;
    add_en <= 1'b0;
    mul_en <= 1'b0;
    counter_en <= 1'b1; 
    counter_loop_en <= 1'b0;
    num_wait <= LOOPS_WAIT; 
    change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
   end
  END: begin
    sel <= 1'b0;               
    change_addr_sel <= 2'b11;
    add_en <= 1'b0;
    mul_en <= 1'b0;
    counter_en <= 1'b0;
    counter_loop_en <= 1'b0;
    num_wait <= 5'd0; 
    change_addr_value <= 5'd0;
     addr_preem_en <= 1'b0;
     write_preem_en <= 1'b0;
     energy_log_en <= 1'b0;
     sel_log <= 2'b11;
     sqr_en <= 1'b0;
     write_energy_log_en <= 1'b0;
     frame_count_en <= 1'b0;
     log_add_en <= 1'b0;
  end        
    endcase
      
endmodule






