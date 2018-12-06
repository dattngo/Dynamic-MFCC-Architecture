module window (clk, rst_n
               , fft_num
               , window_en
               , window_data_in
               , sample_in_frame
               , window_cof_in
               , win_mem_read_addr
               , window_mem_write_addr
               , window_data_out
               , write_win_en
               );

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;
parameter COUNTER_VALUE_WIDTH = 4;
parameter SAMPLE_IN_FRAME_WIDTH = 11;

input clk, rst_n, window_en;
input [DATA_WIDTH-1 : 0] window_data_in, window_cof_in;
input [SAMPLE_IN_FRAME_WIDTH-1 : 0] sample_in_frame;
//input [10:0] fft_num;
input [11:0] fft_num; //////Edited///////

output [DATA_WIDTH-1 : 0] window_data_out;
output [ADDR_WIDTH-1 : 0] win_mem_read_addr;
output [ADDR_WIDTH-1 : 0] window_mem_write_addr;
output write_win_en;

wire counter_over, counter_addr_over, counter_sample_over;
wire [DATA_WIDTH-1 : 0] window_cof_in, mul_data_out;
wire mul_en, counter_en, counter_addr_en, counter_sample_en, fill_zero;
wire [1:0] change_addr_sel;
wire [3:0] counter_value;
wire [ADDR_WIDTH-1 : 0] counter_addr_out; //????????????????????
wire [ADDR_WIDTH-1 : 0] counter_sample_out; //????????????????????
wire [ADDR_WIDTH-1 : 0] sample_in_frame_12bit;

reg [DATA_WIDTH-1 : 0] window_data_out;

assign sample_in_frame_12bit = {1'b0, sample_in_frame};
//assign fft_num_12bit = {1'b0, fft_num};
always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        window_data_out <= 32'd0;
    end        
    else if (fill_zero) begin
        window_data_out <= 32'd0;
    end        
    else begin
        window_data_out <= mul_data_out;
    end        
end        

window_state_ctrl window_state_unit_01 (
     .clk (clk),
     .rst_n (rst_n),
     .window_state_en (window_en),
     .counter_over (counter_over),
     .counter_sample_over (counter_sample_over),
     .mul_en (mul_en),
     .counter_en (counter_en),
     .counter_sample_en (counter_sample_en),
     .counter_value (counter_value),
     .write_win_en (write_win_en),
     .counter_addr_over (counter_addr_over),
     .counter_addr_en (counter_addr_en),
     .fill_zero (fill_zero)
     );

assign window_mem_write_addr = counter_addr_out;

counter counter_unit_02 (
  .clk (clk),
  .rst_n (rst_n),
  .counter_en (counter_en),
  .counter_value (counter_value),
  .counter_over (counter_over));
 
counter_loop counter_addr_unit_02 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_loop_en (counter_addr_en),
    .counter_loop_value (fft_num),
    .counter_loop_out (counter_addr_out),
    .counter_loop_over (counter_addr_over));

counter_loop counter_sample_unit_02 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_loop_en (counter_sample_en),
    .counter_loop_value (sample_in_frame_12bit),
    .counter_loop_out (counter_sample_out),
    .counter_loop_over (counter_sample_over));

mul_fp_clk mul_unit_02 (
    .clk (clk),
    .rst_n (rst_n),
    .ena_mul_fp_clk (mul_en),
    .data_in_1 (window_data_in),
    .data_in_2 (window_cof_in),
    .data_out (mul_data_out));


assign win_mem_read_addr  = counter_sample_out;

endmodule
