module four_mem_cof_ctrl (clk, rst_n
                        , addr_4_mem_in
                        , system_4mem_addr
                        , q_0
                        , q_1
                        , q_2
                        , q_3
                        , system_4mem_cen_sel
                        , system_4mem_wen_in
                        , system_4mem_addr_sel
                        , system_4mem_wen_out
                        , cen_0
                        , cen_1
                        , cen_2
                        , cen_3
                        , addr_4_mem_out
                        , data_4_mem_out
                        );


parameter ADDR_WIDTH_4MEM = 14;
parameter DATA_WIDTH = 32;

input clk, rst_n, system_4mem_addr_sel;
input [ADDR_WIDTH_4MEM-1 : 0] addr_4_mem_in, system_4mem_addr;
input [DATA_WIDTH-1 : 0] q_0, q_1, q_2, q_3;
input system_4mem_wen_in, system_4mem_cen_sel;

output cen_0, cen_1, cen_2, cen_3;
output [DATA_WIDTH-1 : 0] data_4_mem_out;
output [ADDR_WIDTH_4MEM-3 : 0] addr_4_mem_out;
output system_4mem_wen_out;

wire [ADDR_WIDTH_4MEM-1 : 0] addr_4_mem;
wire [1:0] cen_case;

reg [1:0] cen_case_delay;
reg [3:0] cen;
reg [DATA_WIDTH-1 : 0] data_4_mem_out;

assign system_4mem_wen_out = system_4mem_wen_in;
assign addr_4_mem = system_4mem_addr_sel ? addr_4_mem_in : system_4mem_addr;
assign cen_case = addr_4_mem [ADDR_WIDTH_4MEM-1 : ADDR_WIDTH_4MEM-2];
assign {cen_0, cen_1, cen_2, cen_3} = cen;
assign addr_4_mem_out = addr_4_mem [ADDR_WIDTH_4MEM-3 : 0];

always@(cen_case or system_4mem_cen_sel) begin
    if ( ~ system_4mem_cen_sel) begin
        cen <= 4'b0000;
    end
    else begin
    case (cen_case)
        2'b00: begin
            cen <= 4'b1000;
        end    
        2'b01: begin
            cen <= 4'b0100;
        end
        2'b10: begin
            cen <= 4'b0010;
        end
        2'b11: begin
            cen <= 4'b0001;
        end
     endcase
     end
end

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cen_case_delay <= 2'd0;
    end
    else begin
        cen_case_delay <= cen_case; 
    end
end

always@(cen_case_delay or q_0 or q_1 or q_2 or q_3) begin
    case (cen_case_delay)
        2'b00: begin
            data_4_mem_out <= q_0;
        end    
        2'b01: begin
            data_4_mem_out <= q_1;
        end
        2'b10: begin
            data_4_mem_out <= q_2;
        end
        2'b11: begin
            data_4_mem_out <= q_3;
        end
   endcase
end

endmodule
