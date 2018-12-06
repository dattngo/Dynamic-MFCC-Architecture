module eight_mem_cof_ctrl (clk, rst_n
                        , addr_8_mem_in
                        , system_8_mem_addr
                        , q_0
                        , q_1
                        , q_2
                        , q_3
                        , q_4
                        , q_5
                        , q_6
                        , q_7
                        , system_8_mem_cen_sel
                        , system_8_mem_wen_in
                        , system_8_mem_addr_sel
                        , system_8_mem_wen_out
                        , cen_0
                        , cen_1
                        , cen_2
                        , cen_3
                        , cen_4
                        , cen_5
                        , cen_6
                        , cen_7
                        , addr_8_mem_out
                        , data_8_mem_out
                        );

parameter ADDR_WIDTH = 12;
parameter ADDR_WIDTH_8_MEM = 15;
parameter DATA_WIDTH = 32;

input clk, rst_n, system_8_mem_addr_sel;
input [ADDR_WIDTH_8_MEM-1 : 0] addr_8_mem_in, system_8_mem_addr;
input [DATA_WIDTH-1 : 0] q_0, q_1, q_2, q_3, q_4, q_5, q_6, q_7;
input system_8_mem_wen_in, system_8_mem_cen_sel;

output cen_0, cen_1, cen_2, cen_3, cen_4, cen_5, cen_6, cen_7;
output [DATA_WIDTH-1 : 0] data_8_mem_out;
output [ADDR_WIDTH-1 : 0] addr_8_mem_out;
output system_8_mem_wen_out;

wire [ADDR_WIDTH_8_MEM-1 : 0] addr_8_mem_wire;
wire [2:0] cen_case;

reg [2:0] cen_case_delay;
reg [7:0] cen;
reg [DATA_WIDTH-1 : 0] data_8_mem_out;

assign system_8_mem_wen_out = system_8_mem_wen_in;
assign addr_8_mem_wire = system_8_mem_addr_sel ? addr_8_mem_in : system_8_mem_addr;
assign cen_case = addr_8_mem_wire [ADDR_WIDTH_8_MEM-1 : ADDR_WIDTH_8_MEM-3];
assign {cen_0, cen_1, cen_2, cen_3, cen_4, cen_5, cen_6, cen_7} = cen;
assign addr_8_mem_out = addr_8_mem_wire [ADDR_WIDTH-1 : 0];

always@(cen_case or system_8_mem_cen_sel) begin
    if ( ~ system_8_mem_cen_sel) begin
        cen <= 8'b00000000;
    end
    else begin
    case (cen_case)
        3'b000: begin
            cen <= 8'b10000000;
        end    
        3'b001: begin
            cen <= 8'b01000000;
        end
        3'b010: begin
            cen <= 8'b00100000;
        end
        3'b011: begin
            cen <= 8'b00010000;
        end
        3'b100: begin
            cen <= 8'b00001000;
        end    
        3'b101: begin
            cen <= 8'b00000100;
        end
        3'b110: begin
            cen <= 8'b00000010;
        end
        3'b111: begin
            cen <= 8'b00000001;
        end
     endcase
     end
end

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cen_case_delay <= 3'd0;
    end
    else begin
        cen_case_delay <= cen_case; 
    end
end

always@(cen_case_delay or q_0 or q_1 or q_2 or q_3 or q_4 or q_5 or q_6 or q_7) begin
    case (cen_case_delay)
        3'b000: begin
            data_8_mem_out <= q_0;
        end    
        3'b001: begin
            data_8_mem_out <= q_1;
        end
        3'b010: begin
            data_8_mem_out <= q_2;
        end
        3'b011: begin
            data_8_mem_out <= q_3;
        end
        3'b100: begin
            data_8_mem_out <= q_4;
        end    
        3'b101: begin
            data_8_mem_out <= q_5;
        end
        3'b110: begin
            data_8_mem_out <= q_6;
        end
        3'b111: begin
            data_8_mem_out <= q_7;
        end
   endcase
end

endmodule
