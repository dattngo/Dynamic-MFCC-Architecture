module cep_state_ctrl (clk, rst_n
                         , cep_state_en
                         , counter_over
                         , counter_half_frame_over
                         , counter_cep_over
                         , sel_add
                         , counter_half_frame_en
                         , counter_cep_en
                         , addr_cep_en
                         , write_cep_en
                         , counter_en
                         , counter_value
                         , change_addr_sel
                         , mul_en
                         , add_en
                         , frame_count_en
                         , frame_num_out_en
                         );

parameter DATA_WIDTH = 32;
parameter RESET = 5'd0;
parameter START = 5'd1;
parameter READ_0 = 5'd2;
parameter MUL_0 = 5'd3;
parameter ADD_0 = 5'd4;
parameter BRANCH_1 = 5'd5; 
parameter BRANCH_2 = 5'd6;
parameter DATA_CEP_1 = 5'd7;
parameter DATA_CEP_2 = 5'd8;
parameter WRITE_CEP_1 = 5'd9; 
parameter WRITE_CEP_2 = 5'd10;
parameter RE_CALC = 5'd11;
parameter WAIT = 5'd12;
parameter CAL_ADDR = 5'd13;
parameter READ = 5'd14;
parameter MUL = 5'd15;
parameter ADD = 5'd16;
parameter LOOPS_READ = 4'd2;
parameter LOOPS_ADD = 4'd10;
parameter LOOPS_MUL = 4'd10;
parameter LOOPS_WRITE = 4'd2;
parameter LOOPS_CAL = 4'd5;

input clk, rst_n, cep_state_en, counter_over, counter_half_frame_over, counter_cep_over;

output counter_en, counter_half_frame_en, counter_cep_en;
output add_en, mul_en, addr_cep_en, write_cep_en;
output frame_num_out_en, frame_count_en;
output [1:0] change_addr_sel, sel_add;
output [3:0] counter_value;


reg counter_en, counter_half_frame_en, counter_cep_en;
reg add_en, mul_en, addr_cep_en, write_cep_en;
reg frame_count_en, frame_num_out_en;
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


always@(present_state or cep_state_en or counter_half_frame_over or counter_over) begin
    case (present_state)
        RESET: begin
            if (cep_state_en) begin
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
             if (counter_cep_over) begin
             next_state <= DATA_CEP_2;
             end
             else begin
             next_state <= DATA_CEP_1;
             end
        end

        DATA_CEP_1: begin
             next_state <= WRITE_CEP_1;
        end

        DATA_CEP_2: begin
             next_state <= WRITE_CEP_2;
        end

        WRITE_CEP_1: begin
             next_state <= RE_CALC;
        end

        WRITE_CEP_2: begin
             next_state <= WAIT;
        end
        WAIT: begin
            if (cep_state_en) begin
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
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end


        START: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b1;
        change_addr_sel <= 2'b01;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b1;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b1;
        end


        READ_0: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end


        MUL_0: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b1;
        add_en <= 1'b0;
        counter_value <= LOOPS_MUL;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        ADD_0: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b1;
        counter_value <= LOOPS_ADD;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        BRANCH_1: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        BRANCH_2: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b1;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        DATA_CEP_1: begin
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b1;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        DATA_CEP_2: begin
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b1;
        frame_num_out_en <= 1'b0;
        end
        
        WRITE_CEP_1: begin
        sel_add <= 2'b11;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= LOOPS_WRITE;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b1;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        WRITE_CEP_2: begin
        sel_add <= 2'b11;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= LOOPS_WRITE;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b1;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end
        WAIT: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b00;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        RE_CALC: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b1;
        change_addr_sel <= 2'b01;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end
        CAL_ADDR: begin  
        sel_add <= 2'b00;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b1;
        change_addr_sel <= 2'b01;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        READ: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b0;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        counter_value <= 4'd0;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

 
        MUL: begin  
        sel_add <= 2'b01;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b1;
        add_en <= 1'b0;
        counter_value <= LOOPS_MUL;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

        ADD: begin  
        sel_add <= 2'b11;
        counter_en <= 1'b1;
        counter_half_frame_en <= 1'b0;
        change_addr_sel <= 2'b11;
        mul_en <= 1'b0;
        add_en <= 1'b1;
        counter_value <= LOOPS_ADD;
        counter_cep_en <= 1'b0;
        addr_cep_en <= 1'b0;
        write_cep_en <= 1'b0;
        frame_count_en <= 1'b0;
        frame_num_out_en <= 1'b0;
        end

    endcase
end
endmodule

