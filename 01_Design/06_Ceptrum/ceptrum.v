module cep (clk, rst_n
            , cep_state_en
            , cep_num
            , mel_num
            , cep_data_in
            , cep_cof_in
            , cep_cof_read_addr
            , cep_mem_read_addr
            , cep_mem_write_addr
            , cep_data_out
            , write_cep_en
            );

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;
parameter ADDR_WIDTH_14 = 14;
parameter MEL_NUM_WIDTH = 6;

input clk, rst_n, cep_state_en;
input [6:0] cep_num;
input [DATA_WIDTH-1 : 0] cep_data_in, cep_cof_in;
input [MEL_NUM_WIDTH-1 : 0] mel_num;

output [ADDR_WIDTH-1 : 0] cep_cof_read_addr;
wire [ADDR_WIDTH-1 : 0] cep_cof_read_addr;
output write_cep_en;
output [DATA_WIDTH-1 : 0]  cep_data_out;
// 14 bits
output [ADDR_WIDTH_14-1 : 0] cep_mem_write_addr;///DAT///
output [ADDR_WIDTH-1 : 0] cep_mem_read_addr;

wire counter_en, counter_half_frame_en,counter_cep_en, mul_en, add_en, addr_cep_en;
wire counter_over, counter_half_frame_over, counter_cep_over;
wire frame_count_en, frame_num_out_en;
wire [1:0] change_addr_sel, sel_add;
wire [DATA_WIDTH-1 : 0]  mul_data_out, add_data_out;
wire [6:0] counter_cep_out;
wire  [3:0] counter_value;
wire [ADDR_WIDTH_14-1 : 0] cep_mem_write_addr_wire;///DAT///
wire [5:0] cep_mem_read_addr_6bit;

reg [DATA_WIDTH-1 : 0] add_data_in_2;
reg [ADDR_WIDTH_14-1 : 0] cep_mem_write_addr;///DAT///
reg [6:0] counter_frame_out, cep_frame_num;

assign cep_data_out = add_data_out;
assign cep_mem_write_addr_wire = {cep_frame_num, counter_cep_out};///DAT///
assign cep_mem_read_addr = {6'd0, cep_mem_read_addr_6bit};

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cep_frame_num <= 7'd0;
    end
    else if (frame_num_out_en) begin
        cep_frame_num <= counter_frame_out;
    end
    else begin
        cep_frame_num <= cep_frame_num;
    end
end

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter_frame_out <= 7'd0;
    end
    else if (frame_count_en) begin
        counter_frame_out <= counter_frame_out + 1;
    end
    else begin
        counter_frame_out <= counter_frame_out;
    end
end

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cep_mem_write_addr <= 14'd0;///DAT///
    end
    else if (addr_cep_en) begin
        cep_mem_write_addr <= cep_mem_write_addr_wire;
    end
    else begin
        cep_mem_write_addr <= cep_mem_write_addr;
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

cep_state_ctrl cep_state_ctrl_06 (
      .clk (clk) 
    , .rst_n (rst_n)
    , .cep_state_en (cep_state_en)
    , .counter_over (counter_over)
    , .counter_half_frame_over (counter_half_frame_over)
    , .counter_cep_over (counter_cep_over)
    , .sel_add (sel_add)
    , .counter_half_frame_en (counter_half_frame_en)
    , .counter_cep_en (counter_cep_en)
    , .addr_cep_en (addr_cep_en)
    , .write_cep_en (write_cep_en)
    , .counter_en (counter_en)
    , .counter_value (counter_value)
    , .change_addr_sel (change_addr_sel)
    , .mul_en (mul_en)
    , .add_en (add_en)
    , .frame_count_en (frame_count_en)
    , .frame_num_out_en (frame_num_out_en)
     );


counter counter_unit_06 (
     .clk (clk),
     .rst_n (rst_n),
     .counter_en (counter_en),
     .counter_value (counter_value),
     .counter_over (counter_over));

counter_cep_7bit counter_cep_06 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_loop_en (counter_cep_en),
    .counter_loop_value (cep_num),
    .counter_loop_out (counter_cep_out),
    .counter_loop_over (counter_cep_over));

counter_loop_6bit counter_half_frame_06 (
    .clk (clk),
    .rst_n (rst_n),
    .counter_loop_en (counter_half_frame_en),
    .counter_loop_value (mel_num),
    .counter_loop_out (cep_mem_read_addr_6bit),
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
    .data_in_1 (cep_cof_in),
    .data_in_2 (cep_data_in),
    .data_out (mul_data_out));

change_addr addr_unit_06 (
    .clk (clk),
    .rst_n (rst_n),
    .change_addr_value (12'd0),
    .change_addr_sel (change_addr_sel),
    .change_addr_out (cep_cof_read_addr));

endmodule
