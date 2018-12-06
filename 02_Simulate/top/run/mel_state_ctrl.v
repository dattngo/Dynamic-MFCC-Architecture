module mel_state_ctrl (clk, rst_n
                         , mel_state_en
                         , counter_over
                         , counter_half_frame_over
                         , counter_mel_over
                         , sel_add
                         , counter_half_frame_en
                         , counter_mel_en
                         , addr_mel_en
                         , write_mel_en
                         , counter_en
                         , counter_value
                         , change_addr_sel
                         , mul_en
                         , add_en
                         , log_en
                         );

parameter DATA_WIDTH = 32;
parameter RESET = 5'd0;
parameter START = 5'd1;
parameter READ_0 = 5'd2;
parameter MUL_0 = 5'd3;
parameter ADD_0 = 5'd4;
parameter BRANCH_1 = 5'd5; 
parameter BRANCH_2 = 5'd6;
parameter DATA_MEL_1 = 5'd7;
parameter DATA_MEL_2 = 5'd8;
parameter LOG_1 = 5'd9;
parameter LOG_2 = 5'd10;
parameter WRITE_MEL_1 = 5'd11; 
parameter WRITE_MEL_2 = 5'd12;
parameter RE_CALC = 5'd13;
parameter WAIT = 5'd14;
parameter CAL_ADDR = 5'd15;
parameter READ = 5'd16;
parameter MUL = 5'd17;
parameter ADD = 5'd18;
parameter LOOPS_READ = 10'd2;
parameter LOOPS_ADD = 10'd10;
parameter LOOPS_MUL = 10'd10;
parameter LOOPS_WRITE = 10'd2;
parameter LOOPS_CAL = 10'd5;
parameter LOOPS_LOG = 10'd15;

input clk, rst_n, mel_state_en, counter_over, counter_half_frame_over, counter_mel_over;

output counter_en, counter_half_frame_en, counter_mel_en;
output add_en, mul_en, addr_mel_en, write_mel_en, log_en;
output [1:0] change_addr_sel, sel_add;
output [3:0] counter_value;


reg counter_en, counter_half_frame_en, counter_mel_en;
reg add_en, mul_en, addr_mel_en, write_mel_en, log_en;
reg [1:0] change_addr_sel, sel_add;
reg [3:0] counter_value;
reg [4:0] next_state, present_state;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        present_state <= RESET;
    end
    else begin
        present_state <= next_state;
    end
end


always@(present_state or mel_state_en or counter_half_frame_over or counter_over) begin
    case (present_state)
        RESET: begin
             if (mel_state_en) begin
             next_state <= START;
             end
             else begin
             next_state <= RESET;
             end
         end
        START: begin
            next_state <= READ_0;
        end
        READ_0: begin
            next_state <= MUL_0;
        end

        MUL_0: begin
            if (counter_over) begin
            next_state <= ADD_0;
            end
            else begin
            next_state <= MUL_0;
            end
        end

        ADD_0: begin
             if (counter_over) begin
             next_state <= BRANCH_1;
             end
             else begin
             next_state <= ADD_0;
             end
        end

        BRANCH_1: begin
             if (counter_half_frame_over) begin
             next_state <= BRANCH_2;
             end
             else begin
             next_state <= CAL_ADDR;
             end
        end

        BRANCH_2: begin
             if (counter_mel_over) begin
             next_state <= DATA_MEL_2;
             end
             else begin
             next_state <= DATA_MEL_1;
             end
        end

        DATA_MEL_1: begin
             next_state <= LOG_1;
        end

        DATA_MEL_2: begin
             next_state <= LOG_2;
        end

        LOG_1: begin
             if (counter_over) begin
             next_state <= WRITE_MEL_1;
             end
             else begin
             next_state <= LOG_1;
             end
        end
        LOG_2: begin
             if (counter_over) begin
             next_state <= WRITE_MEL_2;
             end
             else begin
             next_state <= LOG_2;
             end
        end
        WRITE_MEL_1: begin
             next_state <= RE_CALC;
        end

        WRITE_MEL_2: begin
             next_state <= WAIT;
        end
        WAIT: begin
            if (mel_state_en) begin
            next_state <= START;
            end
            else begin
            next_state <= WAIT;
            end
        end

        RE_CALC: begin
            next_state <= READ_0;
        end
        CAL_ADDR: begin
            next_state <= READ;
        end
        READ: begin
            next_state <= MUL;
        end 
        MUL: begin
            if (counter_over) begin    
            next_state <= ADD;
            end
            else begin
            next_state <= MUL;
        end
        end
/*
        INC_ADDR: begin
            next_state <= ADD;
        end
*/
        ADD: begin
            if (counter_over) begin    
            next_state <= BRANCH_1;
            end
            else begin
            next_state <= ADD;
            end
        end

    endcase
end

always@(present_state) begin
    case (present_state)
        RESET: begin
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b00;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end


        START: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b1;
        change_addr_sel <= 2'b00;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b1;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end


        READ_0: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end


        MUL_0: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b1;
        add_en <= 1'b0;
        counter_value <= LOOPS_MUL;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

        ADD_0: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b1;
        counter_value <= LOOPS_ADD;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

        BRANCH_1: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

        BRANCH_2: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

        DATA_MEL_1: begin
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b1;
        addr_mel_en <= 1'b1;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

        DATA_MEL_2: begin
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b1;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end
        
        WRITE_MEL_1: begin
        sel_add <= 2'b11;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= LOOPS_WRITE;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b1;
        log_en <= 1'b0;
        end

        WRITE_MEL_2: begin
        sel_add <= 2'b11;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= LOOPS_WRITE;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b1;
        log_en <= 1'b0;
        end
        LOG_1: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= LOOPS_LOG;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b1;
        end
        LOG_2: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= LOOPS_LOG;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b1;
        end
        WAIT: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b00;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

        RE_CALC: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b1;
        change_addr_sel <= 2'b01;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end
        CAL_ADDR: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b1;
        change_addr_sel <= 2'b01;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

        READ: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 10'd0;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

 
        MUL: begin  
        sel_add <= 2'b01;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b1;
        add_en <= 1'b0;
        counter_value <= LOOPS_MUL;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

        ADD: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b1;
        counter_value <= LOOPS_ADD;
        counter_mel_en <= 1'b0;
        addr_mel_en <= 1'b0;
        write_mel_en <= 1'b0;
        log_en <= 1'b0;
        end

    endcase
end
endmodule

