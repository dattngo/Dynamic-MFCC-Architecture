module copy_energy (clk, rst_n
       , copy_energy_en
       , frame_num
       , energy_mem_read_addr
       , energy_mem_write_addr
       , write_energy_to_result_en
             );

parameter ADDR_WIDTH = 12;
parameter ADDR_WIDTH_14 = 14;
input clk, rst_n, copy_energy_en;
input [6:0] frame_num;

output [ADDR_WIDTH-1 : 0] energy_mem_read_addr;
// 14bits
output [ADDR_WIDTH_14-1 : 0] energy_mem_write_addr;///DAT///
output write_energy_to_result_en;
 
wire counter_over, counter_frame_over, counter_en, counter_frame_en, inc_read_addr_en, write_energy_to_result_en, counter_loop_over;
wire [3:0] counter_value;
wire [6:0] counter_mem_write_addr;
wire [6:0] energy_mem_read_addr_7bit;

assign energy_mem_write_addr = {counter_mem_write_addr [6:0], 7'd0};
assign energy_mem_read_addr = {5'd0, energy_mem_read_addr_7bit};

copy_energy_state_ctrl copy_energy_state_01 (
       .clk (clk)
     , .rst_n (rst_n)
     , .copy_energy_en (copy_energy_en)
     , .counter_over (counter_over)
     , .counter_frame_over (counter_frame_over)
     , .counter_en (counter_en)
     , .counter_frame_en (counter_frame_en)
     , .inc_read_addr_en (inc_read_addr_en)
     , .write_energy_to_result_en (write_energy_to_result_en)
     , .counter_value (counter_value)
            );

counter counter_unit_01 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_en (counter_en),
    .counter_value (counter_value),
    .counter_over (counter_over));

counter_loop_7bit counter_frame_unit_01 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_loop_en (inc_read_addr_en),
    .counter_loop_value (frame_num),
    .counter_loop_out (energy_mem_read_addr_7bit),
    .counter_loop_over (counter_frame_over));

counter_loop_7bit counter_loop_unit_01 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_loop_en (counter_frame_en),
    .counter_loop_value (frame_num),
    .counter_loop_out (counter_mem_write_addr),
    .counter_loop_over (counter_loop_over));

endmodule
