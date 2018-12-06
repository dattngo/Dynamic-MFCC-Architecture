module delta (clk, rst_n
            , delta_state_en
            , delta_data_in
            , frame_num
            , cep_num
            , delta_mem_read_write_addr
            , write_delta_en
            , delta_data_out
               );

parameter ADDR_WIDTH = 12;
parameter ADDR_WIDTH_14 = 14;
parameter DATA_WIDTH = 32;

input clk, rst_n, delta_state_en;
input [6:0] frame_num;
input [6:0]  cep_num;
input [DATA_WIDTH-1 : 0] delta_data_in;

// delta_mem_addr 14 bits for 4 memory
output [ADDR_WIDTH_14-1 : 0] delta_mem_read_write_addr;///DAT/// 
output write_delta_en;
output [DATA_WIDTH-1 : 0] delta_data_out;

// delta_mem_addr 14 bits for 4 memory
wire [ADDR_WIDTH_14-1 : 0] delta_mem_read_addr, delta_mem_write_addr;///DAT/// 
wire [1:0] sel_n;
wire counter_frame_over, counter_cep_over, counter_over, counter_en, sel_addr;
wire mul_en, sub_en, add_en, inc_frame_en, inc_cep_en;
wire [6:0] frame_n, frame_num_sub_3;
reg [6:0] read_addr_n;
wire [7:0] n_sub_1_w, n_plus_1_w, n_sub_2_w, n_plus_2_w;
wire [6:0] n_sub_1, n_plus_1, n_sub_2, n_plus_2;
wire [3:0] counter_value;
wire [6:0] cep_n, cep_n_for_write;
wire [7:0] cep_n_for_write_8bit;
wire [DATA_WIDTH-1 : 0] n_2_reg, n_2_mul_2_reg, n_1_reg; 
wire [7:0] frame_num_sub_3_8bit;

reg [DATA_WIDTH-1 : 0] n_sub_1_reg, n_plus_1_reg, n_sub_2_reg, n_plus_2_reg;

assign delta_mem_read_write_addr = sel_addr ? delta_mem_write_addr : delta_mem_read_addr;
assign cep_n_for_write = cep_n_for_write_8bit [6:0];
assign frame_num_sub_3 =  frame_num_sub_3_8bit [6:0];

delta_state_ctrl delta_state_ctrl_01 (
      .clk (clk)
    , .rst_n (rst_n)
    , .delta_state_en (delta_state_en)
    , .counter_frame_over (counter_frame_over)
    , .counter_cep_over (counter_cep_over)
    , .counter_over (counter_over)
    , .sel_n (sel_n)
    , .write_delta_en (write_delta_en)
    , .counter_en (counter_en)
    , .mul_en (mul_en)
    , .sub_en (sub_en)
    , .add_en (add_en)
    , .inc_cep_en (inc_cep_en)
    , .inc_frame_en (inc_frame_en)
    , .sel_addr (sel_addr)
    , .counter_value (counter_value)
                 );

counter counter_unit_01 (
     .clk (clk),
     .rst_n (rst_n),
     .counter_en (counter_en),
     .counter_value (counter_value),
     .counter_over (counter_over)
          );

cla_7bit cla_frame_num_sub_3 (
     .clk (clk),
     .rst_n (rst_n),
     .input_1 (frame_num),
     .input_2 (7'b1111101),
     .c_in (1'b0),
     .sum (frame_num_sub_3_8bit)
        );

counter_frame_delta_7bit counter_frame_delta_01 (
      .clk (clk),
      .rst_n (rst_n),
      .counter_loop_en (inc_frame_en),
      .counter_loop_value (frame_num_sub_3),
      .counter_loop_out (frame_n),
      .counter_loop_over (counter_frame_over));

counter_cep_in_delta_7bit counter_cep_unit_01 (
      .clk (clk),
      .rst_n (rst_n),
      .counter_loop_en (inc_cep_en),
      .counter_loop_value (cep_num),
      .counter_loop_out (cep_n),
      .counter_loop_over (counter_cep_over));

cla_7bit cla_7bit_01 (
     .clk (clk),
     .rst_n (rst_n),
     .input_1 (cep_n),
     .input_2 (cep_num),
     .c_in (1'b1), //////// Note: the carrier = 1
     .sum (cep_n_for_write_8bit));

cla_7bit cla_n_sub_1 (
     .clk (clk),
     .rst_n (rst_n),
     .input_1 (frame_n),
     .input_2 (7'b1111111),
     .c_in (1'b0),
     .sum (n_sub_1_w)
        );

cla_7bit cla_n_plus_1 (
     .clk (clk),
     .rst_n (rst_n),
     .input_1 (frame_n),
     .input_2 (7'd1),
     .c_in (1'b0),
     .sum (n_plus_1_w)
           );

cla_7bit cla_n_sub_2 (
     .clk (clk),
     .rst_n (rst_n),
     .input_1 (frame_n),
     .input_2 (7'b1111110),
     .c_in (1'b0),
     .sum (n_sub_2_w)
           );

cla_7bit cla_n_plus_2 (
     .clk (clk),
     .rst_n (rst_n),
     .input_1 (frame_n),
     .input_2 (7'd2),
     .c_in (1'b0),
     .sum (n_plus_2_w));


add_fp_clk substract_unit_01 (
    .clk (clk),
    .rst_n (rst_n),
    .ena_add_fp_clk (sub_en),
    .data_in_1 (n_plus_1_reg),
    .data_in_2 ( { ~ n_sub_1_reg [31], n_sub_1_reg [30:0]}),
    .data_out (n_1_reg));

add_fp_clk substract_unit_02 (
    .clk (clk),
    .rst_n (rst_n),
    .ena_add_fp_clk (sub_en),
    .data_in_1 (n_plus_2_reg),
    .data_in_2 ({ ~ n_sub_2_reg [31], n_sub_2_reg [30:0]}),
    .data_out (n_2_reg));

mul_fp_clk mul_unit_06 (
     .clk (clk),
     .rst_n (rst_n),
     .ena_mul_fp_clk (mul_en),
     .data_in_1 (n_2_reg),
     .data_in_2 (32'h40000000),
     .data_out (n_2_mul_2_reg));


add_fp_clk add_unit_01 (
    .clk (clk),
    .rst_n (rst_n),
    .ena_add_fp_clk (add_en),
    .data_in_1 (n_2_mul_2_reg),
    .data_in_2 (n_1_reg),
    .data_out (delta_data_out));

assign delta_mem_read_addr = {read_addr_n, cep_n};
assign delta_mem_write_addr = {frame_n, cep_n_for_write};
assign n_plus_2 = n_plus_2_w [6:0];
assign n_sub_2 = n_sub_2_w [6:0];
assign n_plus_1 = n_plus_1_w [6:0];
assign n_sub_1 = n_sub_1_w [6:0];

always@(sel_n or n_sub_1 or n_sub_2 or n_plus_1 or n_plus_2) begin
    case (sel_n)
    2'b00: begin
        read_addr_n <= n_sub_1;
    end
    2'b01: begin
        read_addr_n <= n_plus_1;
    end        
    2'b10: begin
        read_addr_n <= n_sub_2;
    end        
    2'b11: begin
        read_addr_n <= n_plus_2;
    end        
    endcase        
end        

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        n_sub_1_reg <= 32'd0;
        n_plus_1_reg <= 32'd0;
        n_sub_2_reg <= 32'd0;
        n_plus_2_reg <= 32'd0;
    end        
    else begin
    case (sel_n)
    2'b00: begin
        n_sub_1_reg <= delta_data_in;
        n_plus_1_reg <= n_plus_1_reg;
        n_sub_2_reg <= n_sub_2_reg;
        n_plus_2_reg <= n_plus_2_reg;
    end
    2'b01: begin
        n_sub_1_reg <= n_sub_1_reg;
        n_plus_1_reg <= delta_data_in;
        n_sub_2_reg <= n_sub_2_reg;
        n_plus_2_reg <= n_plus_2_reg;
    end        
    2'b10: begin
        n_sub_1_reg <= n_sub_1_reg;
        n_plus_1_reg <= n_plus_1_reg;
        n_sub_2_reg <= delta_data_in;
        n_plus_2_reg <= n_plus_2_reg;
    end        
    2'b11: begin
        n_sub_1_reg <= n_sub_1_reg;
        n_plus_1_reg <= n_plus_1_reg;
        n_sub_2_reg <= n_sub_2_reg;
        n_plus_2_reg <= delta_data_in;
    end        
    endcase   
    end    
end        

endmodule        
