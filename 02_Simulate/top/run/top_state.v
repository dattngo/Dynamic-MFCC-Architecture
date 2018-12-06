module top_state (clk, rst_n
                 , top_state_en
                 , preem_state_en
                 , window_state_en
                 , fft_state_en
                 , amp_state_en
                 , mel_state_en
                 , cep_state_en
                 , delta_state_en
                 , delta_2nd_state_en
                 , counter_en
                 , counter_loop_en
                 , counter_over
                 , counter_loop_over
                 , counter_value
                 , inc_state_en
                 , preem_win_change_mem
                 , win_fft_change_mem
                 , fft_amp_change_mem
                 , amp_mel_change_mem
                 , mel_cep_change_mem
                 , result_change_mem
                 , copy_energy_en
                 , finish_flag
                   );

parameter COUNTER_VALUE_WIDTH = 20;
parameter RESET = 5'd0;
//parameter START = 5'd1;
parameter PRE = 5'd1;
parameter P_W = 5'd2;
parameter P_W_F = 5'd3;
parameter P_W_F_A = 5'd4;
parameter P_W_F_A_M = 5'd5;
parameter P_W_F_A_M_C = 5'd6;
parameter W_F_A_M_C = 5'd7;
parameter F_A_M_C = 5'd8;
parameter A_M_C = 5'd9;
parameter M_C = 5'd10;
parameter CEP = 5'd11;
parameter DELTA = 5'd12;
parameter DELTA_2ND = 5'd13;
parameter ENERGY = 5'd14;
parameter WAIT = 5'd15;
parameter WAIT_N = 5'd16;
parameter WAIT_M = 15'd17;
parameter WAIT_C = 5'd18;
parameter BRANCH = 5'd19;
parameter INC_LOOP = 5'd20;
parameter END = 5'd21;
parameter LOOP_WAIT = 20'd400000;
parameter LOOP_DELTA = 20'd70000;
parameter LOOP_DELTA_2ND = 20'd70000;
parameter LOOP_ENERGY = 20'd1000;

input clk, rst_n, top_state_en, counter_over, counter_loop_over;

output preem_state_en, window_state_en, fft_state_en, amp_state_en, mel_state_en, cep_state_en, delta_state_en, delta_2nd_state_en, copy_energy_en;
output preem_win_change_mem, win_fft_change_mem, fft_amp_change_mem, amp_mel_change_mem, mel_cep_change_mem;
output [2:0] result_change_mem;
output counter_en, counter_loop_en, inc_state_en;
output [COUNTER_VALUE_WIDTH-1 : 0] counter_value;
output finish_flag;

reg preem_state_en, window_state_en, fft_state_en, amp_state_en, mel_state_en, cep_state_en, delta_state_en, delta_2nd_state_en, copy_energy_en;
reg preem_win_change_mem, win_fft_change_mem, fft_amp_change_mem, amp_mel_change_mem, mel_cep_change_mem;
reg [2:0] result_change_mem;
reg counter_en, counter_loop_en, inc_state_en;
reg [4:0] present_state, next_state, state;
reg [COUNTER_VALUE_WIDTH-1 : 0] counter_value;
reg finish_flag;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        present_state <= RESET;
    end
    else begin
        present_state <= next_state;
    end
end

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= PRE;
    end
    else if (inc_state_en) begin
        state <= present_state;
    end
    else begin
        state <= state;
    end    
end

always@(present_state or counter_loop_over or counter_over or top_state_en) begin
    case (present_state)
        RESET: begin
        if (top_state_en) begin        
            next_state <= PRE;
        end 
        else begin
            next_state <= RESET;
        end
        end       

        WAIT: begin
        if (counter_over) begin        
            next_state <= state + 1;
        end 
        else begin
            next_state <= WAIT;
        end
        end       

        PRE: begin
                next_state <= WAIT;
        end

        P_W: begin
                next_state <= WAIT;
        end

        P_W_F: begin
                next_state <= WAIT;
        end

        P_W_F_A: begin
                next_state <= WAIT;
        end

        P_W_F_A_M: begin
                next_state <= WAIT;
        end

        P_W_F_A_M_C: begin
                next_state <= WAIT_N;
        end

        WAIT_N: begin
            if (counter_over) begin
                next_state <= BRANCH;
            end        
            else begin
                next_state <= WAIT_N;
            end
        end

        BRANCH: begin
            if (counter_loop_over) begin
                next_state <= W_F_A_M_C;
            end
            else begin
                next_state <= INC_LOOP;
            end
        end

        INC_LOOP: begin
            next_state <= P_W_F_A_M_C;
        end       

        W_F_A_M_C: begin
                next_state <= WAIT_M;
        end

        F_A_M_C: begin
                next_state <= WAIT_M;
        end

        A_M_C: begin
                next_state <= WAIT_M;
        end

        M_C: begin
                next_state <= WAIT_M;
        end

        WAIT_M: begin
        if (counter_over) begin        
            next_state <= state + 1;
        end 
        else begin
            next_state <= WAIT_M;
        end
        end       

        CEP: begin
                next_state <= WAIT_C;
        end

        WAIT_C: begin
            if (counter_over) begin
                next_state <= ENERGY;
            end
            else begin
                next_state <= WAIT_C;
            end
        end       

        DELTA: begin
            if (counter_over) begin
                next_state <= DELTA_2ND;
            end
            else begin
                next_state <= DELTA;
            end
        end

        DELTA_2ND: begin
            if (counter_over) begin
                next_state <= END;
            end
            else begin
                next_state <= DELTA_2ND;
            end
        end

        ENERGY: begin
            if (counter_over) begin
                    next_state <= DELTA;
            end
            else begin
                next_state <= ENERGY;
            end
        end

        END: begin
            if (top_state_en) begin
                next_state <= PRE;
            end
            else begin
                next_state <= END;
            end
        end
    endcase

end

always@(present_state) begin
    case (present_state)
        RESET: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        inc_state_en <= 1'b0;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        WAIT: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        counter_value <= LOOP_WAIT;
        inc_state_en <= 1'b0;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        PRE: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        P_W: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b1;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        P_W_F: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b1;
        win_fft_change_mem <= 1'b1;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        P_W_F_A: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b1;
        win_fft_change_mem <= 1'b1;
        fft_amp_change_mem <= 1'b1;
        amp_mel_change_mem <= 1'b1;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        P_W_F_A_M: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b1;
        win_fft_change_mem <= 1'b1;
        fft_amp_change_mem <= 1'b1;
        amp_mel_change_mem <= 1'b1;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        P_W_F_A_M_C: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b1;
        win_fft_change_mem <= 1'b1;
        fft_amp_change_mem <= 1'b1;
        amp_mel_change_mem <= 1'b1;
        mel_cep_change_mem <= 1'b1;
        result_change_mem <= 3'b010;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        WAIT_N: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b010;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        counter_value <= LOOP_WAIT;
        inc_state_en <= 1'b0;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        BRANCH: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b0;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        INC_LOOP: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b1;
        counter_value <= 20'd0;
        inc_state_en <= 1'b0;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        WAIT_M: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b010;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        counter_value <= LOOP_WAIT;
        inc_state_en <= 1'b0;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        W_F_A_M_C: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b1;
        win_fft_change_mem <= 1'b1;
        fft_amp_change_mem <= 1'b1;
        amp_mel_change_mem <= 1'b1;
        mel_cep_change_mem <= 1'b1;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        F_A_M_C: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b1;
        fft_amp_change_mem <= 1'b1;
        amp_mel_change_mem <= 1'b1;
        mel_cep_change_mem <= 1'b1;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        A_M_C: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b1;
        amp_mel_change_mem <= 1'b1;
        mel_cep_change_mem <= 1'b1;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        M_C: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b1;
        mel_cep_change_mem <= 1'b1;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        
        CEP: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b1;
        result_change_mem <= 3'b010;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        

        WAIT_C: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b010;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        counter_value <= LOOP_WAIT;
        inc_state_en <= 1'b0;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end   

        DELTA: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b1;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b011;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        counter_value <= LOOP_DELTA;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        

        DELTA_2ND: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b1;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b100;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        counter_value <= LOOP_DELTA_2ND;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b0;
        end        

        ENERGY: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b001;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        counter_value <= LOOP_ENERGY;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b1;
        finish_flag <= 1'b0;
        end        

        END: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        delta_2nd_state_en <= 1'b0;
        preem_win_change_mem <= 1'b0;
        win_fft_change_mem <= 1'b0;
        fft_amp_change_mem <= 1'b0;
        amp_mel_change_mem <= 1'b0;
        mel_cep_change_mem <= 1'b0;
        result_change_mem <= 3'b000;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        counter_value <= 20'd0;
        inc_state_en <= 1'b1;
        copy_energy_en <= 1'b0;
        finish_flag <= 1'b1;
        end        
    endcase        
end        


endmodule
