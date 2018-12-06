module mel (clk, rst_n
            , mel_state_en
            , mel_num
            , fft_num
            , mel_data_in
            , mel_cof_in
            , mel_cof_read_addr
            , mel_mem_read_addr
            , mel_mem_write_addr
            , mel_data_out
            , write_mel_en
            , exp_data_out
            , man_data_out
            , exp_addr
            , man_addr
            );

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;
parameter ADDR_WIDTH_15 = 15;
parameter ADDR_EXP_WIDTH = 12;
parameter ADDR_MAN_WIDTH = 12;

input clk, rst_n, mel_state_en;
input [5:0] mel_num;
input [DATA_WIDTH-1 : 0] mel_data_in, mel_cof_in;
//input [10 : 0] fft_num;
input [11 : 0] fft_num;          ///// Edited///////
input [DATA_WIDTH-1:0] exp_data_out;
input [DATA_WIDTH-1:0] man_data_out;

output [ADDR_EXP_WIDTH-1:0] exp_addr;
output [ADDR_WIDTH_15-1 : 0] mel_cof_read_addr;
wire [ADDR_WIDTH_15-1 : 0] mel_cof_read_addr;
output [ADDR_MAN_WIDTH-1:0] man_addr;
output write_mel_en;
output [DATA_WIDTH-1 : 0]  mel_data_out;
output [ADDR_WIDTH-1 : 0] mel_mem_write_addr, mel_mem_read_addr;

wire counter_en, counter_half_frame_en,counter_mel_en, mul_en, add_en, addr_mel_en, log_mel_en;
wire counter_over, counter_half_frame_over, counter_mel_over;
wire [1:0] change_addr_sel, sel_add;
wire [DATA_WIDTH-1 : 0] mul_data_out, add_data_out, log_data_out;
wire [3:0] counter_value;
wire [5:0] counter_mel_out;
//wire [11:0] fft_num_12bit;

reg [DATA_WIDTH-1 : 0] add_data_in_2;
reg [ADDR_WIDTH-1 : 0] mel_mem_write_addr;

assign mel_data_out =  log_data_out;
//assign fft_num_12bit = {1'b0, fft_num};      /// Edited ///
/*
always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mel_data_out <= 32'd0;
    end
    else if (data_mel_en) begin
        mel_data_out <= log_data_out;
    end
    else begin
        mel_data_out <= mel_data_out;
    end
end
*/
always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mel_mem_write_addr <= 12'd0;
    end
    else if (addr_mel_en) begin
        mel_mem_write_addr <= {6'd0, counter_mel_out};
    end
    else begin
        mel_mem_write_addr <= mel_mem_write_addr;
    end
end

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        add_data_in_2 <= 32'd0;
    end
    else begin
        case (sel_add)
        2'b00: begin
        add_data_in_2 <= 32'd0;
        end
        2'b01, 2'b10: begin
        add_data_in_2 <= add_data_out;
        end
        2'b11: begin
        add_data_in_2 <= add_data_in_2;
        end
        endcase
     end
end

mel_state_ctrl mel_state_ctrl_06 (
      .clk (clk) 
    , .rst_n (rst_n)
    , .mel_state_en (mel_state_en)
    , .counter_over (counter_over)
    , .counter_half_frame_over (counter_half_frame_over)
    , .counter_mel_over (counter_mel_over)
    , .sel_add (sel_add)
    , .counter_half_frame_en (counter_half_frame_en)
    , .counter_mel_en (counter_mel_en)
    , .addr_mel_en (addr_mel_en)
    , .write_mel_en (write_mel_en)
    , .counter_en (counter_en)
    , .counter_value (counter_value)
    , .change_addr_sel (change_addr_sel)
    , .mul_en (mul_en)
    , .add_en (add_en)
    , .log_en (log_mel_en)
     );

log_fp_clk log_unit (
      .clk (clk)
    , .rst_n (rst_n)
    , .ena_log_fp_clk (log_mel_en)
    , .data_in (add_data_out)
    , .data_out (log_data_out)
    , .exp_data_out (exp_data_out)
    , .man_data_out (man_data_out)
    , .exp_addr (exp_addr)
    , .man_addr (man_addr)

    );    

counter counter_unit_06 (
     .clk (clk),
     .rst_n (rst_n),
     .counter_en (counter_en),
     .counter_value (counter_value),
     .counter_over (counter_over));

counter_loop_6bit counter_mel_06 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_loop_en (counter_mel_en),
    .counter_loop_value (mel_num),
    .counter_loop_out (counter_mel_out),
    .counter_loop_over (counter_mel_over));

counter_loop counter_half_frame_06 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_loop_en (counter_half_frame_en),
    .counter_loop_value (fft_num >> 1),
    .counter_loop_out (mel_mem_read_addr),
    .counter_loop_over (counter_half_frame_over));

add_fp_clk add_unit_06 (
   .clk (clk),
   .rst_n (rst_n),
   .ena_add_fp_clk (add_en),
   .data_in_1 (mul_data_out),
   .data_in_2 (add_data_in_2),
   .data_out (add_data_out));
 
mul_fp_clk mul_unit_06 (
    .clk (clk),
    .rst_n (rst_n),
    .ena_mul_fp_clk (mul_en),
    .data_in_1 (mel_cof_in),
    .data_in_2 (mel_data_in),
    .data_out (mul_data_out));

change_addr_15bits addr_15b_unit_06 (
    .clk (clk),
    .rst_n (rst_n),
    .change_addr_value (15'd0),
    .change_addr_sel (change_addr_sel),
    .change_addr_out (mel_cof_read_addr));

endmodule
