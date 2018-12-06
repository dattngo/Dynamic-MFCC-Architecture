module pre_emphasis (clk, rst_n
                     , preem_state_en
                     , sample_in_frame
                     , com_2_ovl
                     , voice_data_in
                     , alpha
                     , preem_mem_write_addr
                     , preem_data_out
                     , preem_mem_read_addr
                     , write_preem_en
                     , energy_log_data_out
                     , energy_log_frame_num
                     , write_energy_en
                     , exp_data_out
                     , man_data_out
                     , exp_addr
                     , man_addr
                     );
 
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;
parameter OVL_BITS_WIDTH = 12;
parameter ADDR_EXP_WIDTH = 12;
parameter ADDR_MAN_WIDTH = 12;

input clk, rst_n, preem_state_en;
input [DATA_WIDTH-1 : 0] voice_data_in;
input [DATA_WIDTH-1 : 0] alpha;
input [OVL_BITS_WIDTH-1:0] com_2_ovl;
input [10:0] sample_in_frame;
input [DATA_WIDTH-1:0] exp_data_out;
input [DATA_WIDTH-1:0] man_data_out;

output [ADDR_EXP_WIDTH-1:0] exp_addr;
output [ADDR_MAN_WIDTH-1:0] man_addr;
output [DATA_WIDTH-1 : 0] preem_data_out, energy_log_data_out;
output [ADDR_WIDTH-1 : 0] preem_mem_read_addr;
output [ADDR_WIDTH-1 : 0] preem_mem_write_addr;
output write_preem_en, write_energy_en;
output [ADDR_WIDTH-1 :0] energy_log_frame_num;

wire sel, add_en, mul_en, counter_en, addr_preem_en, counter_over;
wire [3:0] num_wait;
wire [ADDR_WIDTH-1 : 0] change_addr_value, change_addr_out;
wire [1:0] change_addr_sel; 
wire [DATA_WIDTH-1 : 0] add_data_in_1, mul_data_in_1, mul_data_in_2, mul_data_out;
wire counter_loop_over;
wire energy_log_en, write_energy_log_en, frame_count_en;
wire [DATA_WIDTH-1 : 0] sqr_data_out, log_data_out, log_add_data_out;
wire sqr_en, log_add_en;
wire [1:0] sel_log;
wire [11:0] sample_in_frame_12bit;

reg [ADDR_WIDTH-1 : 0] counter_frame_out;
reg [DATA_WIDTH-1 : 0] add_data_in_2, log_add_data_in_2, log_add_data_in_1;

assign write_energy_en = write_energy_log_en;
assign energy_log_data_out = log_data_out;
assign energy_log_frame_num = counter_frame_out;
assign sample_in_frame_12bit = {1'd0, sample_in_frame};

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      counter_frame_out <= 12'd1; // address of log energy begin at 1
    end
    else if (frame_count_en) begin
      counter_frame_out <= counter_frame_out + 1;
    end
    else begin
      counter_frame_out <= counter_frame_out;
    end
end

preem_state_ctrl state_unit_01 (
        .clk (clk),
        .rst_n (rst_n),  
        .preem_state_en (preem_state_en), 
        .counter_over(counter_over), 
        .com_2_ovl (com_2_ovl),  
        .num_wait (num_wait) , 
        .sel (sel), 
        .change_addr_sel (change_addr_sel), 
        .change_addr_value (change_addr_value), 
        .add_en (add_en), 
        .mul_en (mul_en), 
        .counter_en (counter_en),
        .counter_loop_en (counter_loop_en),
        .counter_loop_over (counter_loop_over),
        .write_preem_en (write_preem_en),
        .addr_preem_en (addr_preem_en),
        .energy_log_en (energy_log_en),
        .sqr_en (sqr_en),
        .sel_log (sel_log),
        .write_energy_log_en (write_energy_log_en),
        .frame_count_en (frame_count_en),
        .log_add_en (log_add_en)
);



counter counter_unit_01 (
        .clk (clk),
        .rst_n (rst_n), 
        .counter_en (counter_en), 
        .counter_value (num_wait), 
        .counter_over (counter_over));

counter_loop counter_loop_preem_01 (
        .clk (clk), 
        .rst_n (rst_n), 
        .counter_loop_en (counter_loop_en), 
        .counter_loop_value (sample_in_frame_12bit), 
        .counter_loop_out (preem_mem_write_addr), 
        .counter_loop_over (counter_loop_over));

add_fp_clk add_unit_01 (
        .clk (clk),
        .rst_n (rst_n),
        .ena_add_fp_clk (add_en),
        .data_in_1 (add_data_in_1),
        .data_in_2 (add_data_in_2),
        .data_out (preem_data_out));

add_fp_clk log_add_unit_01 (
        .clk (clk),
        .rst_n (rst_n),
        .ena_add_fp_clk (log_add_en),
        .data_in_1 (log_add_data_in_1),
        .data_in_2 (log_add_data_in_2),
        .data_out (log_add_data_out)
          );

mul_fp_clk mul_unit_01 (
        .clk (clk),
        .rst_n (rst_n),
        .ena_mul_fp_clk (mul_en),
        .data_in_1 (mul_data_in_1),
        .data_in_2 (mul_data_in_2),
        .data_out (mul_data_out));

mul_fp_clk square_unit_01 (
        .clk (clk),
        .rst_n (rst_n),
        .ena_mul_fp_clk (sqr_en),
        .data_in_1 (mul_data_in_1),
        .data_in_2 (mul_data_in_1),
        .data_out (sqr_data_out));

change_addr addr_unit_01 (
        .clk (clk), 
        .rst_n (rst_n), 
        .change_addr_value (change_addr_value), 
        .change_addr_sel (change_addr_sel), 
        .change_addr_out (change_addr_out));

 
log_fp_clk energy_log (
       .clk (clk)
     , .rst_n (rst_n)
     , .ena_log_fp_clk (energy_log_en)
     , .data_in (log_add_data_out)
     , .data_out (log_data_out)
     , .exp_data_out (exp_data_out)
     , .man_data_out (man_data_out)
     , .exp_addr (exp_addr)
     , .man_addr (man_addr)

      );

// mux to choose input of MUL
always@(sel or mul_data_out) begin
    if (~sel) begin
      add_data_in_2 <= 32'd0;
    end
    else begin
      add_data_in_2 <= mul_data_out;
    end
end

/*
always@(posedge clk or negedge rst_n) begin
    if (~sel_log) begin
        log_add_data_in_2 <= 32'd0;
    end
    else if (frame_count_en) begin
        log_add_data_in_2 <= 32'd0;
    end
    else begin
        log_add_data_in_2 <= log_add_data_out;
    end
end
*/

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin 
        log_add_data_in_1 <= 32'd0;
    end
    else begin
       case (sel_log)
        2'b00: begin
        log_add_data_in_1 <= 32'd0;
        end
        2'b01, 2'b10, 2'b11: begin
        log_add_data_in_1 <= sqr_data_out;
        end
     endcase
    end
end

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin 
        log_add_data_in_2 <= 32'd0;
    end
    else begin
       case (sel_log)
        2'b00: begin
        log_add_data_in_2 <= 32'd0;
        end
        2'b01, 2'b10: begin
        log_add_data_in_2 <= log_add_data_out;
        end
        2'b11: begin
        log_add_data_in_2 <= log_add_data_in_2;
     end
     endcase
    end
end


//assign log_add_data_in_1 = sqr_data_out;
assign preem_mem_read_addr =  change_addr_out;
assign add_data_in_1 = voice_data_in;
assign mul_data_in_1 = voice_data_in;
assign mul_data_in_2 = alpha;

endmodule
 
