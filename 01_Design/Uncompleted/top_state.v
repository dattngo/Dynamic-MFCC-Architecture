module top_state (clk, rst_n
                 , top_state_en
                 , preem_state_en
                 , window_state_en
                 , fft_state_en
                 , amp_state_en
                 , mel_state_en
                 , cep_state_en
                 , delta_state_en
                 , counter_en
                 , counter_loop_en
                 , counter_over
                 , counter_loop_over
                   );

parameter RESET = 5'd0;
parameter START = 5'd1;
parameter PRE = 5'd2;
parameter P_W = 5'd3;
parameter P_W_F = 5'd4;
parameter P_W_F_A = 5'd5;
parameter P_W_F_A_M = 5'd6;
parameter P_W_F_A_M_C_0 = 5'd7;
parameter BRANCH_0 = 5'd8;
parameter P_W_F_A_M_C_1 = 5'd9;
parameter BRANCH_1 = 5'd10;
parameter W_F_A_M_C_0 = 5'd11;
parameter F_A_M_C_0 = 5'd12;
parameter A_M_C_0 = 5'd13;
parameter M_C_0 = 5'd14;
parameter W_F_A_M_C_1 = 5'd15;
parameter F_A_M_C_1 = 5'd16;
parameter A_M_C_1 = 5'd17;
parameter M_C_1 = 5'd18;
parameter CEP = 5'd19;
parameter DELTA = 5'd20;
parameter ENERGY = 5'd21;
parameter END = 5'd22;

input clk, rst_n, top_state_en, counter_over, counter_loop_over;

output preem_state_en, window_state_en, fft_state_en, mag_state_en, mel_state_en, cep_state_en, delta_state_en;
output preem_win_mem_sel, win_fft_mem_sel, fft_amp_mem_sel, amp_mel_mem_sel, mel_cep_mem_sel;
output [1:0] result_mem_sel;
output counter_en, counter_loop_en;

reg preem_state_en, window_state_en, fft_state_en, mag_state_en, mel_state_en, cep_state_en, delta_state_en;
reg preem_win_mem_sel, win_fft_mem_sel, fft_amp_mem_sel, amp_mel_mem_sel, mel_cep_mem_sel;
reg [1:0] result_mem_sel;
reg counter_en, counter_loop_en;
reg [4:0] present_state, next_state;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        present_state <= RESET;
    end
    else begin
        present_state <= next_state;
    end
end

always@(present_state or counter_loop_over or counter_over) begin
    case (present_state)
        RESET: begin
            next_state <= START;
        end        
        START: begin
            next_state <= PRE;
        end        
        PRE: begin
            if (counter_over) begin
                next_state <= P_W;
            end
            else begin
                next_state <= PRE;
            end
        end
        P_W: begin
            if (counter_over) begin
                next_state <= P_W_F;
            end
            else begin
                next_state <= P_W;
            end
        end
        P_W_F: begin
            if (counter_over) begin
                next_state <= P_W_F_A;
            end
            else begin
                next_state <= P_W_F;
            end
        end
        P_W_F_A: begin
            if (counter_over) begin
                next_state <= P_W_F_A_M;
            end
            else begin
                next_state <= P_W_F_A;
            end
        end
        P_W_F_A_M: begin
            if (counter_over) begin
                next_state <= BRANCH_0;
            end
            else begin
                next_state <= P_W_F_A_M;
            end
        end
        BRANCH_0: begin
            if (counter_loop_over) begin
                next_state <= W_F_A_M_C_0;
            end
            else begin
                next_state <= INC_LOOP_0;
            end
        end
        INC_LOOP_0: begin
            next_state <= P_W_F_A_M_C_0;
        end        
        P_W_F_A_M_C_0: begin
            if (counter_over) begin
                next_state <= BRANCH_1;
            end        
            else begin
                next_state <= P_W_F_A_M_C_0;
            end
        end
        BRANCH_1: begin
            if (counter_loop_over) begin
                next_state <= W_F_A_M_C_1;
            end
            else begin
                next_state <= INC_LOOP_1;
            end
        end
        INC_LOOP_1: begin
            next_state <= P_W_F_A_M_C_1;
        end        
        P_W_F_A_M_C_1: begin
            if (counter_over) begin
                next_state <= BRANCH_0;
            end        
            else begin
                next_state <= P_W_F_A_M_C_1;
            end
        end
        W_F_A_M_C_1: begin
            if (counter_over) begin
                next_state <= F_A_M_C_1;
            end
            else begin
                next_state <= W_F_A_M_C_1;
            end
        end
        F_A_M_C_1: begin
            if (counter_over) begin
                next_state <= A_M_C_1;
            end
            else begin
                next_state <= F_A_M_C_1;
            end
        end
        A_M_C_1: begin
            if (counter_over) begin
                next_state <= M_C_1;
            end
            else begin
                next_state <= A_M_C_1;
            end
        end
        M_C_1: begin
            if (counter_over) begin
                next_state <= CEP;
            end
            else begin
                next_state <= M_C_1;
            end
        end
        CEP: begin
            if (counter_over) begin
                next_state <= DELTA;
            end
            else begin
                next_state <= CEP;
            end
        end
        DELTA: begin
            if (counter_over) begin
                next_state <= ENERGY;
            end
            else begin
                next_state <= DELTA;
            end
        end
        ENERGY: begin
            if (counter_over) begin
                    next_state <= END;
            end
            else begin
                next_state <= ENERGY;
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
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        end        
        START: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b0;
        end        
        PRE: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        P_W: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b1;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        P_W_F: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b1;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        P_W_F_A: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b1;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b1;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        P_W_F_A_M: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b1;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b1;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        BRANCH_0: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        INC_LOOP_0: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b1;
        end        
        P_W_F_A_M_C_0: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        W_F_A_M_C_0: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        F_A_M_C_0: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        A_M_C_0: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        M_C_0: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        BRANCH_1: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        INC_LOOP_1: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b0;
        counter_loop_en <= 1'b1;
        end        
        P_W_F_A_M_C_1: begin
        preem_state_en <= 1'b1; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        W_F_A_M_C_1: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b1;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        F_A_M_C_1: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b1;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        A_M_C_1: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b1;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        M_C_1: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b1;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        CEP: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b1;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        DELTA: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b1;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
        END: begin
        preem_state_en <= 1'b0; 
        window_state_en <= 1'b0;
        fft_state_en <= 1'b0;
        amp_state_en <= 1'b0;
        mel_state_en <= 1'b0;
        cep_state_en <= 1'b0;
        delta_state_en <= 1'b0;
        preem_win_mem_sel <= 1'b0;
        win_fft_mem_sel <= 1'b0;
        fft_amp_mem_sel <= 1'b0;
        amp_mel_mem_sel <= 1'b0;
        mel_cep_mem_sel <= 1'b0;
        result_mem_sel <= 2'b00;
        counter_en <= 1'b1;
        counter_loop_en <= 1'b0;
        end        
    endcase        
end        


end
