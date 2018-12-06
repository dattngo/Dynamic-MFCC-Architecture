

//TOTAL 3 CLK32
module max_pair_compare (clk, rst_n, compare_input_01, compare_input_02, compare_result);

parameter DATA_WIDTH = 32;

input clk;
input rst_n;
input [DATA_WIDTH-1:0] compare_input_01;
input [DATA_WIDTH-1:0] compare_input_02;

output [DATA_WIDTH-1:0]compare_result;
reg    [DATA_WIDTH-1:0]compare_result;


//Internal Signal
wire [7:0] pre_exponent_01;
wire [7:0] pre_exponent_02;

wire [22:0]pre_significant_01;
wire [22:0]pre_significant_02;

reg [7:0] exponent_01;
reg [7:0] exponent_02;

reg [22:0]significant_01;
reg [22:0]significant_02;

reg [1:0]significant_case;
reg [1:0]exponent_case;
//MAIN FUNCTION

assign pre_exponent_01 = compare_input_01[DATA_WIDTH-2:DATA_WIDTH-9];
assign pre_exponent_02 = compare_input_02[DATA_WIDTH-2:DATA_WIDTH-9];

assign pre_significant_01 = compare_input_01[DATA_WIDTH-10:0];
assign pre_significant_02 = compare_input_02[DATA_WIDTH-10:0];

// 1 CLK32
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        significant_01 <= 0;
    end
    else begin
        significant_01 <= pre_significant_01;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        significant_02 <= 0;
    end
    else begin
        significant_02 <= pre_significant_02;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        exponent_01 <= 0;
    end
    else begin
        exponent_01 <= pre_exponent_01;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        exponent_02 <= 0;
    end
    else begin
        exponent_02 <= pre_exponent_02;
    end
end

//======================= 2 CLK32
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        exponent_case <= 0;   
    end
    else if(exponent_02 > exponent_01)begin
        exponent_case <= 2'b10;
    end
    else if(exponent_02 < exponent_01) begin
        exponent_case <= 2'b01;
    end
    else begin
        exponent_case <= 2'b11;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        significant_case <= 0;   
    end
    else if(significant_02 >= significant_01)begin
        significant_case <= 2'b10;
    end
    else begin
        significant_case <= 2'b01;
    end
end

//===================== 3 CLK32
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        compare_result <= 0;   
    end
    else if(exponent_case == 2'b10)begin
        compare_result <= compare_input_02;
    end
    else if(exponent_case == 2'b01)begin
        compare_result <= compare_input_01;
    end
    else begin
        if(significant_case == 2'b10) begin
            compare_result <= compare_input_02;
        end
        else begin
            compare_result <= compare_input_01;
        end
    end
end

endmodule
