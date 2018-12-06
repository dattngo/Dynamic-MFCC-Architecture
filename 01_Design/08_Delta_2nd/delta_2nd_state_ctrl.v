module delta_2nd_state_ctrl (clk, rst_n
                         , delta_2nd_state_en
                         , counter_frame_over
                         , counter_cep_over
                         , counter_over
                         , sel_n
                         , write_delta_2nd_en
                         , counter_en
                         , mul_en
                         , sub_en
                         , add_en
                         , inc_cep_en
                         , inc_frame_en
                         , sel_addr
                         , counter_value
                         );

parameter DATA_WIDTH = 32;
parameter RESET = 4'd0;
parameter N_SUB_1 = 4'd1;
parameter N_PLUS_1 = 4'd2;
parameter N_SUB_2 = 4'd3;
parameter N_PLUS_2 = 4'd4;
parameter SUB = 4'd5;
parameter MUL = 4'd6;
parameter ADD = 4'd7;
parameter WRITE = 4'd8;
parameter BRANCH_1 = 4'd9;
parameter BRANCH_2 = 4'd10;
parameter INC_CEP = 4'd11;
parameter INC_FRAME = 4'd12;
parameter END = 4'd13;
parameter LOOPS_WRITE = 4'd2;
parameter LOOPS_READ = 4'd3;
parameter LOOPS_SUB = 4'd10;
parameter LOOPS_ADD = 4'd10;
parameter LOOPS_MUL = 4'd10;


input clk, rst_n, delta_2nd_state_en, counter_over, counter_cep_over, counter_frame_over;

output [1:0] sel_n;
output write_delta_2nd_en, counter_en, mul_en, sub_en, add_en, inc_frame_en, inc_cep_en, sel_addr;
output [3:0] counter_value;

reg [1:0] sel_n;
reg write_delta_2nd_en, counter_en, mul_en, sub_en, add_en, inc_frame_en, inc_cep_en, sel_addr;
reg [3:0] next_state, present_state;
reg [3:0] counter_value;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        present_state <= RESET;
    end
    else begin
        present_state <= next_state;
    end
end


always@(present_state or delta_2nd_state_en or counter_frame_over or counter_cep_over or counter_over) begin
    case (present_state)
        RESET: begin
            if (delta_2nd_state_en) begin
            next_state <= N_SUB_1;
            end        
            else begin
            next_state <= RESET;
            end
        end
        N_SUB_1: begin
            if (counter_over) begin
            next_state <= N_PLUS_1;
            end
            else begin
            next_state <= N_SUB_1;
            end
        end
        N_PLUS_1: begin
            if (counter_over) begin
            next_state <= N_SUB_2;
            end
            else begin
            next_state <= N_PLUS_1;
            end
        end
        N_SUB_2: begin
            if (counter_over) begin
            next_state <= N_PLUS_2;
            end
            else begin
            next_state <= N_SUB_2;
            end
        end
        N_PLUS_2: begin
            if (counter_over) begin
            next_state <= SUB;
            end
            else begin
            next_state <= N_PLUS_2;
            end
        end
        SUB: begin
            if (counter_over) begin    
            next_state <= MUL;
            end
            else begin
            next_state <= SUB;
            end
        end
        MUL: begin
            if (counter_over) begin    
            next_state <= ADD;
            end
            else begin
            next_state <= MUL;
            end
        end

        ADD: begin
            if (counter_over) begin    
            next_state <= WRITE;
            end
            else begin
            next_state <= ADD;
            end
        end

        WRITE: begin
            if (counter_over) begin    
            next_state <= BRANCH_1;
            end
            else begin
            next_state <= WRITE;
            end 
        end

        BRANCH_1: begin
            if (counter_cep_over) begin
            next_state <= BRANCH_2;
            end
            else begin
            next_state <= INC_CEP;
            end
        end

        INC_CEP: begin
            next_state <= N_SUB_1;
        end

        BRANCH_2: begin
            if (counter_frame_over) begin
            next_state <= END;
            end
            else begin
            next_state <= INC_FRAME;
            end
        end
        INC_FRAME: begin
            next_state <= N_SUB_1;
        end
    endcase
end

always@(present_state) begin
    case (present_state)
        RESET: begin
        sel_n <= 2'b00;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b0;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= 4'd0;
        end

        N_SUB_1: begin
        sel_n <= 2'b00;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b1;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= LOOPS_READ;
        end    

        N_PLUS_1: begin
        sel_n <= 2'b01;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b1;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= LOOPS_READ;
        end    

        N_SUB_2: begin
        sel_n <= 2'b10;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b1;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= LOOPS_READ;
        end    

        N_PLUS_2: begin
        sel_n <= 2'b11;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b1;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= LOOPS_READ;
        end    

        SUB: begin
        sel_n <= 2'b11;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b1;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b1;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= LOOPS_SUB;
        end    

        MUL: begin
        sel_n <= 2'b11;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b1;
        mul_en <= 1'b1;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= LOOPS_SUB;
        end   

        ADD: begin
        sel_n <= 2'b00;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b1;
        mul_en <= 1'b0;
        add_en <= 1'b1;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b1;
        counter_value <= LOOPS_ADD;
        end    

        BRANCH_1: begin
        sel_n <= 2'b00;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b0;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= 4'd0;
        end    

        INC_CEP: begin
        sel_n <= 2'b00;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b0;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b1;
        sel_addr <= 1'b0;
        counter_value <= 4'd0;
        end    

        INC_FRAME: begin
        sel_n <= 2'b00;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b0;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b1;
        inc_cep_en <= 1'b1;
        sel_addr <= 1'b0;
        counter_value <= 4'd0;
        end    

        WRITE: begin
        sel_n <= 2'b00;
        write_delta_2nd_en <= 1'b1;
        counter_en <= 1'b1;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b1;
        counter_value <= LOOPS_WRITE;
        end

        END: begin
        sel_n <= 2'b00;
        write_delta_2nd_en <= 1'b0;
        counter_en <= 1'b0;
        mul_en <= 1'b0;
        add_en <= 1'b0;
        sub_en <= 1'b0;
        inc_frame_en <= 1'b0;
        inc_cep_en <= 1'b0;
        sel_addr <= 1'b0;
        counter_value <= 4'd0;
        end    
    endcase
end

endmodule
