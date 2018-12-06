module log_fp_clk(
                clk
              , rst_n
              , ena_log_fp_clk
              , data_in
              , data_out
              , exp_data_out
              , man_data_out
              , exp_addr
              , man_addr
              );

parameter DATA_WIDTH = 32;
parameter DATA_EXP_WIDTH = 8;
parameter DATA_MAN_WIDTH = 12;

parameter ADDR_EXP_WIDTH = 12;
parameter ADDR_MAN_WIDTH = 12;


input [DATA_WIDTH-1:0]data_in;
input clk;
input rst_n;
input ena_log_fp_clk;
input [DATA_WIDTH-1:0] exp_data_out;
input [DATA_WIDTH-1:0] man_data_out;

output [ADDR_EXP_WIDTH-1:0] exp_addr;
output [ADDR_MAN_WIDTH-1:0] man_addr;
output [DATA_WIDTH-1:0]data_out;

//-----------------Internal-Signal----------------//
wire [DATA_EXP_WIDTH-1:0] exp_data_in;
wire [DATA_MAN_WIDTH-1:0] man_data_in;
wire [DATA_WIDTH-1:0] log2;
wire [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] exp_data_out_MUL_log2;
wire [DATA_WIDTH-1:0] data_out_wire;
wire [7:0] exp_addr_8bit;

reg [DATA_WIDTH-1:0] dff_data_in;
reg [DATA_WIDTH-1:0] data_out;

//----------------------------------------------//
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        dff_data_in <= 0;
    end
    else if(ena_log_fp_clk)begin
        dff_data_in <= data_in;
    end
    else begin
        dff_data_in <= dff_data_in;
    end
end

assign exp_addr = {4'd0, exp_addr_8bit};

//-----------------Extraction------------------//
assign exp_data_in = {data_in[30:23]};
assign man_data_in = {data_in[22:11]};
assign exp_addr_8bit   = {data_in[30:23]};
assign man_addr    = {data_in[22:11]};
assign log2        = 32'b00111110100110100010000010011011;

/*
mem_exponent mem_exponent_01 (.clk(clk)
                             ,.addr(exp_addr)
                             ,.cen(1'b1)
                             ,.wen(1'b0)
                             ,.data(32'd0)
                             ,.q(exp_data_out)
                             );

mem_mantissa mem_mantissa_01 (.clk(clk)
                             ,.addr(man_addr)
                             ,.cen(1'b1)
                             ,.wen(1'b0)
                             ,.data(32'd0)
                             ,.q(man_data_out)
                             );
*/

mul_fp_clk mul_unit_01 (.clk (clk)
                      , .rst_n (rst_n)
                      , .ena_mul_fp_clk(1'b1)
                      , .data_in_1 (exp_data_out)
                      , .data_in_2 (log2)
                      , .data_out (exp_data_out_MUL_log2));
 
add_fp_clk add_unit_01 (.clk (clk)
                      , .rst_n (rst_n)
                      , .ena_add_fp_clk(1'b1)
                      , .data_in_1 (man_data_out)
                      , .data_in_2 (exp_data_out_MUL_log2)
                      , .data_out (data_out_wire));

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_out <= 0;
    end
    else if(ena_log_fp_clk)begin
        data_out <= data_out_wire;
    end
    else begin
        data_out <= data_out;
    end
end
 
endmodule



