module max_min_fp_clk(clk,rst_n
                  ,ena_max_min_fp_clk
                  ,data_in_1
                  ,data_in_2
                  ,data_out_max
                  ,data_out_min
                  );

parameter DATA_WIDTH = 32;

input clk;
input rst_n;
input ena_max_min_fp_clk;

input [DATA_WIDTH-1 : 0] data_in_1;
input [DATA_WIDTH-1 : 0] data_in_2;

output[DATA_WIDTH-1 : 0] data_out_max;
output[DATA_WIDTH-1 : 0] data_out_min;

reg [DATA_WIDTH-1 : 0] dff_data_in_1;
reg [DATA_WIDTH-1 : 0] dff_data_in_2;
reg [DATA_WIDTH-1 : 0] data_out_max;
reg [DATA_WIDTH-1 : 0] data_out_min;

wire [DATA_WIDTH-1 : 0] data_out_max_wire;
wire [DATA_WIDTH-1 : 0] data_out_min_wire;

wire [DATA_WIDTH-1 : 0] data_in_1;
wire [DATA_WIDTH-1 : 0] data_in_2;
wire [DATA_WIDTH-1 : 0] abs_data_in_1;
wire [DATA_WIDTH-1 : 0] abs_data_in_2;

assign abs_data_in_1 = {1'b0,data_in_1[30:0]};
assign abs_data_in_2 = {1'b0,data_in_2[30:0]};

//////////////////////////////////
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
       dff_data_in_1 <= 0;
    end
    else if(ena_max_min_fp_clk)begin
       dff_data_in_1 <= abs_data_in_1;
    end
    else begin
       dff_data_in_1 <= 0;
    end
end
         
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
       dff_data_in_2 <= 0;
    end
    else if(ena_max_min_fp_clk)begin
       dff_data_in_2 <= abs_data_in_2;
    end
    else begin
       dff_data_in_2 <= 0;
    end
end

max_pair_compare max_pair_compare_01( .clk(clk)
                                    , .rst_n(rst_n)
                                    , .compare_input_01(dff_data_in_1)
                                    , .compare_input_02(dff_data_in_2)
                                    , .compare_result(data_out_max_wire)
                                    );

min_pair_compare min_pair_compare_01( .clk(clk)
                                    , .rst_n(rst_n)
                                    , .compare_input_01(dff_data_in_1)
                                    , .compare_input_02(dff_data_in_2)
                                    , .compare_result(data_out_min_wire)
                                    );

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
    data_out_max <= 0;
    end
    else if(ena_max_min_fp_clk)begin
    data_out_max <= data_out_max_wire;
    end
    else begin
    data_out_max <= data_out_max;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
    data_out_min <= 0;
    end
    else if(ena_max_min_fp_clk)begin
    data_out_min <= data_out_min_wire;
    end
    else begin
    data_out_min <= data_out_min;
    end
end

endmodule






