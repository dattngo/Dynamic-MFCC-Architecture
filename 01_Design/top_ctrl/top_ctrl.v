module top_ctrl (clk, rst_n
       , frame_num_middle
       , top_state_en
       , preem_state_en
       , window_state_en
       , fft_state_en
       , amp_state_en
       , mel_state_en
       , cep_state_en
       , copy_energy_en
       , delta_state_en
       , delta_2nd_state_en
       , preem_win_mem_sel
       , win_fft_mem_sel
       , fft_amp_mem_sel
       , amp_mel_mem_sel
       , mel_cep_mem_sel
       , result_change_mem
       , finish_flag
          );

parameter COUNTER_VALUE_WIDTH = 20;
         
input clk, rst_n;
input top_state_en;
input [7:0] frame_num_middle; // 8 bits

//output preem_en, window_en, fft_en, amp_en, mel_en, cep_en, delta_en;
output preem_state_en, window_state_en, fft_state_en, amp_state_en, mel_state_en, cep_state_en, delta_state_en, delta_2nd_state_en, copy_energy_en; 
output preem_win_mem_sel, win_fft_mem_sel, fft_amp_mem_sel, amp_mel_mem_sel, mel_cep_mem_sel;
output [2:0] result_change_mem;
output finish_flag;

wire [COUNTER_VALUE_WIDTH-1 : 0] counter_value;
wire counter_loop_over, counter_over, counter_loop_en, counter_en, inc_state_en;
wire preem_win_change_mem, win_fft_change_mem, fft_amp_change_mem, amp_mel_change_mem, mel_cep_change_mem;
wire [6:0] frame_num_middle_7bit;

reg preem_win_mem_sel, win_fft_mem_sel, fft_amp_mem_sel, amp_mel_mem_sel, mel_cep_mem_sel;

assign frame_num_middle_7bit = frame_num_middle [6:0];

top_state top_state_unit (
        .clk (clk)
      , .rst_n (rst_n)
      , .top_state_en (top_state_en)
      , .preem_state_en (preem_state_en)
      , .window_state_en (window_state_en)
      , .fft_state_en (fft_state_en)
      , .amp_state_en (amp_state_en)
      , .mel_state_en (mel_state_en)
      , .cep_state_en (cep_state_en)
      , .delta_state_en (delta_state_en)
      , .delta_2nd_state_en (delta_2nd_state_en)
      , .counter_en (counter_en) 
      , .counter_loop_en (counter_loop_en)
      , .counter_over (counter_over)
      , .counter_loop_over (counter_loop_over)
      , .counter_value (counter_value)
      , .inc_state_en (inc_state_en)
      , .preem_win_change_mem (preem_win_change_mem)
      , .win_fft_change_mem (win_fft_change_mem)
      , .fft_amp_change_mem (fft_amp_change_mem)
      , .amp_mel_change_mem (amp_mel_change_mem)
      , .mel_cep_change_mem (mel_cep_change_mem)
      , .result_change_mem (result_change_mem)
      , .copy_energy_en (copy_energy_en)
      , .finish_flag (finish_flag)
               );

counter_top counter_top_unit (
           .clk (clk)
         , .rst_n (rst_n)
         , .counter_en (counter_en)
         , .counter_value (counter_value)
         , .counter_over (counter_over)
                 );


counter_loop_top_7bit counter_loop_top_01 (
     .clk (clk),
     .rst_n (rst_n),
     .counter_loop_en (counter_loop_en),
     .counter_loop_value (frame_num_middle_7bit),
     .counter_loop_over (counter_loop_over));

always@(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            preem_win_mem_sel <= 1'b0;
        end        
        else if (preem_win_change_mem) begin
            preem_win_mem_sel <= ~ preem_win_mem_sel;
        end        
        else begin
            preem_win_mem_sel <= preem_win_mem_sel;
        end        
end

always@(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            win_fft_mem_sel <= 1'b0;
        end        
        else if (win_fft_change_mem) begin
            win_fft_mem_sel <= ~ win_fft_mem_sel;
        end        
        else begin
            win_fft_mem_sel <= win_fft_mem_sel;
        end        
end

always@(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            fft_amp_mem_sel <= 1'b0;
        end        
        else if (fft_amp_change_mem) begin
            fft_amp_mem_sel <= ~ fft_amp_mem_sel;
        end        
        else begin
            fft_amp_mem_sel <= fft_amp_mem_sel;
        end        
end

always@(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            amp_mel_mem_sel <= 1'b0;
        end        
        else if (amp_mel_change_mem) begin
            amp_mel_mem_sel <= ~ amp_mel_mem_sel;
        end        
        else begin
            amp_mel_mem_sel <= amp_mel_mem_sel;
        end        
end

always@(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mel_cep_mem_sel <= 1'b0;
        end        
        else if (mel_cep_change_mem) begin
            mel_cep_mem_sel <= ~ mel_cep_mem_sel;
        end        
        else begin
            mel_cep_mem_sel <= mel_cep_mem_sel;
        end        
end

endmodule
