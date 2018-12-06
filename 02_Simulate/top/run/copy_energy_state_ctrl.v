module copy_energy_state_ctrl (
            clk
          , rst_n
          , copy_energy_en
          , counter_over
          , counter_frame_over
          , counter_en
          , counter_frame_en
          , inc_read_addr_en
          , write_energy_to_result_en
          , counter_value
           );

parameter ADDR_WIDTH = 12;
parameter RESET = 3'd0; 
parameter INC_WR_ADDR = 3'd1;
parameter READ = 3'd2;
parameter WRITE = 3'd3;
parameter BRANCH = 3'd4;
parameter INC_RD_ADDR = 3'd5;
parameter END = 3'd6;
parameter LOOPS_WRITE = 4'd2;
parameter LOOPS_READ = 4'd3;

input clk, rst_n, copy_energy_en;
input counter_over, counter_frame_over;

output counter_en, counter_frame_en, inc_read_addr_en, write_energy_to_result_en;
output [3:0] counter_value;

reg counter_en, counter_frame_en, inc_read_addr_en, write_energy_to_result_en;
reg [3:0] counter_value;
reg [2:0] present_state, next_state; 

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        present_state <= RESET;   
    end        
    else begin
        present_state <= next_state;
    end    
end 

always@(present_state or copy_energy_en or counter_over or counter_frame_over) begin
    case (present_state)
        RESET: begin
        if (copy_energy_en) begin
            next_state <= INC_RD_ADDR;
        end        
        else begin
            next_state <= RESET;
        end    
        end

        INC_RD_ADDR: begin
            next_state <= READ;
        end        

        READ: begin
        if (counter_over) begin
            next_state <= WRITE;
        end        
        else begin
            next_state <= READ;
        end
        end

        WRITE: begin
        if (counter_over) begin
            next_state <= BRANCH;
        end        
        else begin
            next_state <= WRITE;
        end
        end

        BRANCH: begin
        if (counter_frame_over) begin
            next_state <= END;       
        end        
        else begin
            next_state <= INC_WR_ADDR;
        end        
        end      

        INC_WR_ADDR: begin
            next_state <= INC_RD_ADDR;
        end        

    endcase        
end

always@(present_state) begin
    case (present_state)
        RESET: begin
        counter_en <= 1'b0;
        counter_frame_en <= 1'b0;
        inc_read_addr_en <= 1'b0;
        write_energy_to_result_en <= 1'b0;
        counter_value <= 4'd0;
        end   

        INC_WR_ADDR: begin
        counter_en <= 1'b0;
        counter_frame_en <= 1'b1;
        inc_read_addr_en <= 1'b0;
        counter_value <= 4'd0;
        write_energy_to_result_en <= 1'b0;
        end 

        READ: begin
        counter_en <= 1'b1;
        counter_frame_en <= 1'b0;
        inc_read_addr_en <= 1'b0;
        counter_value <= LOOPS_READ;
        write_energy_to_result_en <= 1'b0;
        end   

        WRITE: begin
        counter_en <= 1'b1;
        counter_frame_en <= 1'b0;
        inc_read_addr_en <= 1'b0;
        counter_value <= LOOPS_WRITE;
        write_energy_to_result_en <= 1'b1;
        end  

        BRANCH: begin
        counter_en <= 1'b0;
        counter_frame_en <= 1'b0;
        inc_read_addr_en <= 1'b0;
        counter_value <= 4'd0;
        write_energy_to_result_en <= 1'b0;
        end  

        INC_RD_ADDR: begin
        counter_en <= 1'b0;
        counter_frame_en <= 1'b0;
        inc_read_addr_en <= 1'b1;
        counter_value <= 4'd0;
        write_energy_to_result_en <= 1'b0;
        end        

        END: begin
        counter_en <= 1'b0;
        counter_frame_en <= 1'b0;
        inc_read_addr_en <= 1'b0;
        counter_value <= 4'd0;
        write_energy_to_result_en <= 1'b0;
        end        
    endcase        
end        


endmodule

