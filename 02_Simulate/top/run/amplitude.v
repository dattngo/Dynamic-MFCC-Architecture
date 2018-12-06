module amplitude(clk, rst_n
                     , ampli_state_en
                     , quarter
                     , fft_num
                     , fft_real_data_in
                     , fft_image_data_in
                     , ampli_mem_write_addr
                     , ampli_data_out
                     , ampli_mem_read_addr
                     , write_ampli_data_en
                     );
 
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;
parameter FRAME_SIZE = 8'd128;

input clk, rst_n, ampli_state_en;
//input [10:0] fft_num;
input [11:0] fft_num;    /////Edited ////
input [DATA_WIDTH-1 : 0] fft_real_data_in;
input [DATA_WIDTH-1 : 0] fft_image_data_in;
input [DATA_WIDTH-1 : 0] quarter;

output [DATA_WIDTH-1 : 0] ampli_data_out;
output [ADDR_WIDTH-1 : 0] ampli_mem_read_addr;
output [ADDR_WIDTH-1 : 0] ampli_mem_write_addr;
output write_ampli_data_en;

wire  add_en, mul_en, write_ampli_data_en, write_ampli_addr_en, counter_en, counter_over, ena_max_min_fp_clk;
wire [DATA_WIDTH-1 : 0]data_out_max_wire;
wire [DATA_WIDTH-1 : 0]data_out_min_wire;
wire [DATA_WIDTH-1 : 0]fft_real_data_in_wire;
wire [DATA_WIDTH-1 : 0]fft_image_data_in_wire;

wire [3:0] num_wait;
wire [ADDR_WIDTH-1 : 0]change_addr_value, change_addr_out;
wire [1 : 0] change_addr_sel;
wire [DATA_WIDTH-1 : 0] quarter_wire;
wire [DATA_WIDTH-1 : 0] quarter_MUL_data_out_min;      
wire counter_loop_over;
wire [ADDR_WIDTH-1 : 0] counter_loop_out;
wire [DATA_WIDTH-1 : 0] add_data_out;
//wire [ADDR_WIDTH-1 : 0] fft_num_12bit;

reg  [ADDR_WIDTH-1 : 0] ampli_mem_write_addr;
reg  [DATA_WIDTH-1 : 0 ]ampli_data_out;

//assign fft_num_12bit = {1'b0, fft_num};

amplitude_state_ctrl ampli_unit_01 (
        .clk (clk),
        .rst_n (rst_n),  
        .ampli_state_en (ampli_state_en), 
        .counter_over(counter_over), 
        .num_wait (num_wait) , 
        .add_en (add_en), 
        .mul_en (mul_en),
        .write_ampli_data_en (write_ampli_data_en),
        .write_ampli_addr_en (write_ampli_addr_en),
        .ena_max_min_fp_clk (ena_max_min_fp_clk),
        .change_addr_sel (change_addr_sel),
        .change_addr_value (change_addr_value), 
        .counter_en (counter_en),
        .counter_loop_en (counter_loop_en),
        .counter_loop_over (counter_loop_over));

counter counter_unit_01 (
        .clk (clk),
        .rst_n (rst_n), 
        .counter_en (counter_en), 
        .counter_value (num_wait), 
        .counter_over (counter_over));

counter_loop counter_loop_amp_01 (
        .clk (clk), 
        .rst_n (rst_n), 
        .counter_loop_en (counter_loop_en), 
        .counter_loop_value (fft_num >> 1), 
        .counter_loop_out (counter_loop_out), 
        .counter_loop_over (counter_loop_over));

max_min_fp_clk max_min_fp_clk_01 (
        .clk (clk),
        .rst_n (rst_n),
        .ena_max_min_fp_clk (ena_max_min_fp_clk),
        .data_in_1 (fft_real_data_in_wire),
        .data_in_2 (fft_image_data_in_wire),
        .data_out_max (data_out_max_wire),
        .data_out_min (data_out_min_wire)
        );

add_fp_clk add_unit_01 (
        .clk (clk),
        .rst_n (rst_n),
        .ena_add_fp_clk (add_en),
        .data_in_1 (data_out_max_wire),
        .data_in_2 (quarter_MUL_data_out_min),
        .data_out (add_data_out));

mul_fp_clk mul_unit_01 (
        .clk (clk),
        .rst_n (rst_n),
        .ena_mul_fp_clk (mul_en),
        .data_in_1 (quarter_wire),
        .data_in_2 (data_out_min_wire),
        .data_out (quarter_MUL_data_out_min));

change_addr change_addr_01 (
        .clk (clk),
        .rst_n (rst_n),
        .change_addr_value (change_addr_value),
        .change_addr_sel (change_addr_sel),
        .change_addr_out (change_addr_out));

assign ampli_mem_read_addr =  change_addr_out;
assign quarter_wire = quarter;
assign fft_real_data_in_wire = fft_real_data_in;
assign fft_image_data_in_wire = fft_image_data_in;

always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
    ampli_mem_write_addr <= 12'd0;
    end
    else if(write_ampli_addr_en)begin
    ampli_mem_write_addr <= counter_loop_out;
    end
    else begin
    ampli_mem_write_addr <= ampli_mem_write_addr;
    end
 end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
    ampli_data_out <= 32'd0;
    end
    else begin
    ampli_data_out <= add_data_out;
    end
 end

endmodule
 
