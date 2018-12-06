module top (clk, rst_n
           , top_state_en
           , frame_num
           , sample_in_frame
           , com_2_ovl
           , alpha
           , quarter
           , fft_num
           , fft_stage_number
           , mel_num
           , cep_num
           , max_point_fft_core
           , system_voice_sel
           , system_voice_cen
           , system_voice_wen
           , system_voice_addr
           , system_voice_write_data_in
           , system_win_cof_addr
           , system_win_cof_sel
           , system_win_cof_cen
           , system_win_cof_wen
           , system_write_win_cof_data_in
           , system_w_real_cof_sel
           , system_w_real_cof_cen
           , system_w_real_cof_wen
           , system_w_real_cof_addr
           , system_write_w_real_cof_data_in
           , system_w_image_cof_sel
           , system_w_image_cof_cen
           , system_w_image_cof_wen
           , system_w_image_cof_addr
           , system_write_w_image_cof_data_in
           , system_8_mem_cen_sel
           , system_8_mem_wen_in
           , system_8_mem_addr_sel
           , system_8_mem_addr
           , system_write_cep_cof_data_in
           , system_cep_cof_sel
           , system_cep_cof_cen
           , system_cep_cof_wen
           , system_cep_cof_addr
           , system_energy_log_cen
           , system_mel_cof_write_data
           , system_result_4_mem_addr
           , system_result_4_mem_cen_sel
           , system_result_4_mem_addr_sel
           , system_result_4_mem_wen_in
           , system_preem_exp_cen
           , system_preem_exp_wen
           , system_preem_man_cen
           , system_preem_man_wen
           , system_preem_exp_data_in
           , system_preem_man_data_in
           , system_mel_exp_cen
           , system_mel_exp_wen
           , system_mel_man_cen
           , system_mel_man_wen
           , system_mel_exp_data_in
           , system_mel_man_data_in
           , result_data_out
           , finish_flag
            );

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;
parameter ADDR_WIDTH_15 = 15;
parameter ADDR_WIDTH_14 = 14;
parameter STAGE_NUM_WIDTH = 10;
parameter ADDR_EXP_WIDTH = 12; ////////Edited///////
parameter ADDR_MAN_WIDTH = 12;

input clk, rst_n;
input top_state_en;
input [6:0] frame_num;
input [10:0] sample_in_frame;
input [ADDR_WIDTH-1 : 0] com_2_ovl;
input [DATA_WIDTH-1 : 0] alpha, quarter;
input [11:0] fft_num;          ////////Edited///////
input [3:0] fft_stage_number; // ??? How many bits Stage_num?
input [5:0] mel_num;
input [6:0] cep_num;
input [15:0]max_point_fft_core;


input [DATA_WIDTH-1 : 0] system_voice_write_data_in;
input system_voice_sel, system_voice_wen, system_voice_cen; 
input [ADDR_WIDTH-1 : 0] system_voice_addr;   
input [ADDR_WIDTH-1 : 0] system_win_cof_addr;     
input system_win_cof_sel, system_win_cof_cen, system_win_cof_wen;
input [DATA_WIDTH-1 : 0] system_write_win_cof_data_in;

input system_w_real_cof_sel, system_w_real_cof_cen, system_w_real_cof_wen;
input [ADDR_WIDTH-1 : 0] system_w_real_cof_addr;
input [DATA_WIDTH-1 : 0] system_write_w_real_cof_data_in;

input system_w_image_cof_sel, system_w_image_cof_cen, system_w_image_cof_wen;
input [ADDR_WIDTH-1 : 0] system_w_image_cof_addr;
input [DATA_WIDTH-1 : 0] system_write_w_image_cof_data_in;

input system_8_mem_addr_sel, system_8_mem_wen_in, system_8_mem_cen_sel;
input [ADDR_WIDTH_15-1 : 0] system_8_mem_addr;
input system_energy_log_cen;
input system_cep_cof_sel, system_cep_cof_cen, system_cep_cof_wen;
input [DATA_WIDTH-1 : 0] system_write_cep_cof_data_in;
input [DATA_WIDTH-1 : 0] system_mel_cof_write_data;
input [ADDR_WIDTH-1 : 0] system_cep_cof_addr;
input system_result_4_mem_wen_in, system_result_4_mem_cen_sel, system_result_4_mem_addr_sel;
input [ADDR_WIDTH_14-1 : 0] system_result_4_mem_addr;///DAT///

input system_preem_exp_cen, system_preem_exp_wen, system_preem_man_cen, system_preem_man_wen;
input [DATA_WIDTH-1 : 0] system_preem_exp_data_in, system_preem_man_data_in;
input system_mel_exp_cen, system_mel_exp_wen, system_mel_man_cen, system_mel_man_wen;
input [DATA_WIDTH-1 : 0] system_mel_exp_data_in, system_mel_man_data_in;

output [DATA_WIDTH-1 : 0] result_data_out;
output finish_flag;

// Settings

// top

wire result_cen_0, result_cen_1, result_cen_2, result_cen_3;
//wire result_wen_0, result_wen_1, result_wen_2, result_wen_3;
wire [ADDR_WIDTH-1 : 0] result_addr_out;/////DAT/////
wire [ADDR_WIDTH_14-1 : 0] result_addr_in; ///DAT///
//


// Pre_emphasis
wire preem_state_en;
wire preem_win_mem_sel, amp_mel_mem_sel;
wire preem_win_wen_1, preem_win_wen_2;
wire preem_win_cen_1, preem_win_cen_2;
wire [ADDR_WIDTH-1 : 0] win_mem_read_addr, preem_mem_write_addr, preem_mem_read_addr, preem_win_addr_1, preem_win_addr_2;
wire [DATA_WIDTH-1 : 0] preem_data_out, preem_win_data_out_1, preem_win_data_out_2, energy_log_data_out;
wire [ADDR_WIDTH-1 : 0] energy_log_frame_num;
wire write_preem_en, write_energy_en;
wire energy_wen;
wire [ADDR_WIDTH-1 : 0] energy_addr;
wire [DATA_WIDTH-1 : 0] result_energy_data_out;
wire [DATA_WIDTH-1:0] preem_exp_data_out;
wire [DATA_WIDTH-1:0] preem_man_data_out;
wire [ADDR_EXP_WIDTH-1:0] preem_exp_addr;
wire [ADDR_MAN_WIDTH-1:0] preem_man_addr;

// Window
wire window_state_en;
wire win_cof_cen, win_cof_wen, write_win_en;
wire [ADDR_WIDTH-1 : 0] window_mem_write_addr, win_cof_addr_out;
wire [DATA_WIDTH-1 : 0] window_data_in, window_cof_in, window_data_out, system_write_win_cof_data_out;

// mem between Win and FFT

wire win_fft_cen_1, win_fft_cen_2, win_fft_wen_1, win_fft_wen_2, win_fft_mem_sel;
wire [ADDR_WIDTH-1 : 0] win_fft_addr_1, win_fft_addr_2;
wire [DATA_WIDTH-1 : 0] win_fft_data_out_1, win_fft_data_out_2;

// FFT

wire fft_state_en;
wire [ADDR_WIDTH-1 : 0] fft_mem_read_addr, fft_real_mem_write_addr, fft_image_mem_write_addr, fft_w_addr;
wire [DATA_WIDTH-1 : 0] fft_real_w_data, fft_image_w_data, fft_data_in;
wire write_fft_real_en, write_fft_image_en;

wire [DATA_WIDTH-1 : 0] data_rd_int_01, data_rd_int_02, data_rd_int_03, data_rd_int_04, data_rd_int_05, data_rd_int_06;
wire [DATA_WIDTH-1 : 0] data_wr_int_01, data_wr_int_02, data_wr_int_03, data_wr_int_04, data_wr_int_05, data_wr_int_06;
wire wr_ena_int_01, wr_ena_int_02, wr_ena_int_04, wr_ena_int_05;
wire [ADDR_WIDTH-1 : 0] addr_mem_int_01, addr_mem_int_02, addr_mem_int_04, addr_mem_int_05;

wire w_real_cen, w_real_wen;
wire [ADDR_WIDTH-1 : 0] fft_w_real_addr_out;
wire [DATA_WIDTH-1 : 0] system_write_w_real_cof_data_out;


wire w_image_cen, w_image_wen;
wire [ADDR_WIDTH-1 : 0] fft_w_image_addr_out;
wire [DATA_WIDTH-1 : 0] system_write_w_image_cof_data_out;
// mem between FFT and Amp

wire fft_amp_mem_sel, fft_amp_real_cen_1, fft_amp_real_cen_2, fft_amp_real_wen_1, fft_amp_real_wen_2;
wire [ADDR_WIDTH-1 : 0] fft_amp_real_addr_1, fft_amp_real_addr_2;
wire [DATA_WIDTH-1 : 0] fft_amp_real_data_out_1, fft_amp_real_data_out_2;
wire fft_amp_image_cen_1, fft_amp_image_cen_2, fft_amp_image_wen_1, fft_amp_image_wen_2;
wire [ADDR_WIDTH-1 : 0] fft_amp_image_addr_1, fft_amp_image_addr_2;
wire [DATA_WIDTH-1 : 0] fft_amp_image_data_out_1, fft_amp_image_data_out_2;
wire [ADDR_WIDTH-1 : 0] amp_mem_write_addr, amp_mem_read_addr;
wire [DATA_WIDTH-1 : 0] amp_real_data_in, amp_image_data_in;

// Amplitude
wire amp_mel_wen_1, amp_mel_wen_2;
wire amp_mel_cen_1, amp_mel_cen_2;
wire [ADDR_WIDTH-1 : 0] mel_mem_read_addr, mel_mem_write_addr;
wire [DATA_WIDTH-1 : 0] amp_data_out, amp_mel_data_out_1, amp_mel_data_out_2;
wire write_amp_en;

// mem between amp and mel
wire [ADDR_WIDTH-1 : 0] amp_mel_addr_1, amp_mel_addr_2;

// Mel
wire mel_state_en;
wire write_mel_en;
wire mel_cof_cen_0, mel_cof_cen_1, mel_cof_cen_2, mel_cof_cen_3;
wire mel_cof_wen_out;

wire [DATA_WIDTH-1:0] mel_exp_data_out;
wire [DATA_WIDTH-1:0] mel_man_data_out;
wire [ADDR_EXP_WIDTH-1:0] mel_exp_addr;
wire [ADDR_MAN_WIDTH-1:0] mel_man_addr;

//Note: address for 4 coefficient mems has width 15 bits
wire [ADDR_WIDTH_15-1 : 0] mel_cof_read_addr;
wire [ADDR_WIDTH-1 : 0] mel_cof_addr_out;
wire [DATA_WIDTH-1 : 0] mel_data_in, mel_data_out, mel_cof_in;

// 4 mems Mel Coefficients
wire [DATA_WIDTH-1 : 0] mel_cof_q_0, mel_cof_q_1, mel_cof_q_2, mel_cof_q_3, mel_cof_q_4, mel_cof_q_5, mel_cof_q_6, mel_cof_q_7;

// between mel and cep

wire [ADDR_WIDTH-1 : 0] mel_cep_addr_1, mel_cep_addr_2;
wire mel_cep_wen_1, mel_cep_wen_2, mel_cep_cen_1, mel_cep_cen_2;
wire [DATA_WIDTH-1 : 0] mel_cep_data_out_1, mel_cep_data_out_2;

// Ceptrum
wire cep_state_en;
wire write_cep_en;
wire cep_cof_cen, cep_cof_wen;
wire [ADDR_WIDTH_14-1 : 0] cep_mem_write_addr; ///DAT///
wire [ADDR_WIDTH-1 : 0] cep_cof_read_addr, cep_cof_addr_out, cep_mem_read_addr;
wire [DATA_WIDTH-1 : 0] system_write_cep_cof_data_out, cep_data_in, cep_data_out, cep_cof_in;


// copy_energy
wire write_energy_to_result_en;
wire copy_energy_en;
wire [ADDR_WIDTH-1 : 0] energy_mem_read_addr;
wire [ADDR_WIDTH_14-1 : 0] energy_mem_write_addr;

// Delta

wire delta_state_en, write_delta_en;
wire [DATA_WIDTH-1 : 0] delta_data_out;

// Delta_2nd

wire delta_2nd_state_en, write_delta_2nd_en;
wire [DATA_WIDTH-1 : 0] delta_2nd_data_out;

// result
wire [DATA_WIDTH-1 : 0] result_data_out;
wire result_wen_out, result_4_mem_wen_out;
wire [ADDR_WIDTH_14-1 : 0] delta_mem_read_write_addr;

wire [ADDR_WIDTH_14-1 : 0] delta_2nd_mem_read_write_addr;
wire [DATA_WIDTH-1 : 0] result_write_data, result_q_0, result_q_1, result_q_2, result_q_3;

//============ Top ==============================

wire [7:0] frame_num_middle; // 8 bits
wire [2:0] result_change_mem;

top_ctrl top_ctrl_unit_01 (
        .clk (clk)
      , .rst_n (rst_n)
      , .frame_num_middle (frame_num_middle)
      , .top_state_en (top_state_en)
      , .preem_state_en (preem_state_en)
      , .window_state_en (window_state_en)
      , .fft_state_en (fft_state_en)
      , .amp_state_en (amp_state_en)
      , .mel_state_en (mel_state_en)
      , .cep_state_en (cep_state_en)
      , .delta_state_en (delta_state_en)
      , .delta_2nd_state_en (delta_2nd_state_en)
      , .preem_win_mem_sel (preem_win_mem_sel)
      , .win_fft_mem_sel (win_fft_mem_sel)
      , .fft_amp_mem_sel (fft_amp_mem_sel)
      , .amp_mel_mem_sel (amp_mel_mem_sel)
      , .mel_cep_mem_sel (mel_cep_mem_sel)
      , .result_change_mem (result_change_mem)
      , .copy_energy_en (copy_energy_en)
      , .finish_flag (finish_flag)
           );
                       
cla_7bit cla_frame_num_middle (
     .clk (clk),
     .rst_n (rst_n),
     .input_1 (frame_num),
     .input_2 (7'b1111010), // minus 6
     .c_in (1'b0),
     .sum (frame_num_middle)
       );

//============ Pre-emphasis =====================

wire voice_cen, voice_wen;
wire [ADDR_WIDTH-1 : 0] voice_addr;
wire [DATA_WIDTH-1 : 0] voice_data_in, system_voice_write_data_out;


mem_input_data voice_mem_01 (
      .clk (clk)
    , .cen (voice_cen)
    , .wen (voice_wen)
    , .addr (voice_addr)
    , .data (system_voice_write_data_out)
    , .q (voice_data_in)
         );

one_mem_cof_ctrl voice_mem_ctrl (
          .system_sel (system_voice_sel)
        , .cen_in (system_voice_cen)
        , .read_wen (1'b1)
        , .system_wen (system_voice_wen)
        , .read_addr (preem_mem_read_addr)
        , .system_addr (system_voice_addr)
        , .write_data_in (system_voice_write_data_in)
        , .cen_out (voice_cen)
        , .wen_out (voice_wen)
        , .addr_out (voice_addr)
        , .write_data_out (system_voice_write_data_out)
        );


mem_exponent mem_exponent_01 (.clk(clk)
                             ,.addr(preem_exp_addr)
                             ,.cen(system_preem_exp_cen)
                             ,.wen(system_preem_exp_wen)
                             ,.data(system_preem_exp_data_in)
                             ,.q(preem_exp_data_out)
                             );

mem_mantissa mem_mantissa_01 (.clk(clk)
                             ,.addr(preem_man_addr)
                             ,.cen(system_preem_man_cen)
                             ,.wen(system_preem_man_wen)
                             ,.data(system_preem_man_data_in)
                             ,.q(preem_man_data_out)
                             );


pre_emphasis pre_emphasis_01 (
     .clk (clk),
     .rst_n (rst_n),
     .preem_state_en (preem_state_en),
     .sample_in_frame (sample_in_frame),
     .com_2_ovl (com_2_ovl),
     .voice_data_in (voice_data_in),
     .alpha (alpha),
     .preem_mem_write_addr (preem_mem_write_addr),
     .preem_data_out (preem_data_out),
     .preem_mem_read_addr (preem_mem_read_addr),
     .write_preem_en (write_preem_en),
     .energy_log_data_out (energy_log_data_out),
     .energy_log_frame_num (energy_log_frame_num),
     .write_energy_en (write_energy_en),
     .exp_data_out (preem_exp_data_out),
     .man_data_out (preem_man_data_out),
     .exp_addr (preem_exp_addr),
     .man_addr (preem_man_addr)
      
       );

mem_ctrl preem_win_ctrl (
      .mem_sel (preem_win_mem_sel)
    , .read_en (1'b0)
    , .write_en (write_preem_en)
    , .read_addr (win_mem_read_addr)
    , .write_addr (preem_mem_write_addr)
    , .q_1 (preem_win_data_out_1)
    , .q_2 (preem_win_data_out_2)
    , .state_en_1 (preem_state_en)
    , .state_en_2 (window_state_en)
    , .cen_1 (preem_win_cen_1)
    , .cen_2 (preem_win_cen_2)
    , .wen_1 (preem_win_wen_1)
    , .wen_2 (preem_win_wen_2)
    , .addr_1 (preem_win_addr_1)
    , .addr_2 (preem_win_addr_2)
    , .data_out (window_data_in)
      );

memory preem_win_mem_01 (
      .clk (clk)
    , .cen (preem_win_cen_1)
    , .wen (preem_win_wen_1)
    , .addr (preem_win_addr_1)
    , .data (preem_data_out)
    , .q (preem_win_data_out_1)
         );

memory preem_win_mem_02 (
      .clk (clk)
    , .cen (preem_win_cen_2)
    , .wen (preem_win_wen_2)
    , .addr (preem_win_addr_2)
    , .data (preem_data_out)
    , .q (preem_win_data_out_2)
         );

one_mem_data_ctrl energy_mem_ctrl (
        .sel (copy_energy_en)
      , .wen_0 (write_energy_en)
      , .wen_1 (1'b0)
      , .addr_0 (energy_log_frame_num)
      , .addr_1 (energy_mem_read_addr)
      , .wen (energy_wen)
      , .addr (energy_addr)
            );

memory energy_log_mem_02 (
      .clk (clk)
    , .cen (system_energy_log_cen)
    , .wen (energy_wen)
    , .addr (energy_addr)
    , .data (energy_log_data_out)
    , .q (result_energy_data_out)
         );


//========== Window ==========================       

window window_02 (
       .clk (clk),
       .rst_n (rst_n),
       .fft_num (fft_num),
       .window_en (window_state_en),
       .window_cof_in (window_cof_in),
       .sample_in_frame (sample_in_frame),
       .window_data_in (window_data_in),
       .win_mem_read_addr (win_mem_read_addr),
       .window_mem_write_addr (window_mem_write_addr),
       .window_data_out (window_data_out),
       .write_win_en (write_win_en)
        );

one_mem_cof_ctrl win_cof_ctrl (
          .system_sel (system_win_cof_sel)
        , .cen_in (system_win_cof_cen)
        , .read_wen (1'b1)
        , .system_wen (system_win_cof_wen)
        , .read_addr (win_mem_read_addr)
        , .system_addr (system_win_cof_addr)
        , .write_data_in (system_write_win_cof_data_in)
        , .cen_out (win_cof_cen)
        , .wen_out (win_cof_wen)
        , .addr_out (win_cof_addr_out)
        , .write_data_out (system_write_win_cof_data_out)
        );

mem_window_cof win_cof_mem_01 (
      .clk (clk)
    , .cen (win_cof_cen)
    , .wen (win_cof_wen)
    , .addr (win_cof_addr_out)
    , .data (system_write_win_cof_data_out)
    , .q (window_cof_in)
         );


mem_ctrl win_fft_ctrl (
      .mem_sel (win_fft_mem_sel)
    , .read_en (1'b0)
    , .write_en (write_win_en)
    , .read_addr (fft_mem_read_addr)
    , .write_addr (window_mem_write_addr)
    , .state_en_1 (window_state_en)
    , .state_en_2 (fft_state_en)
    , .cen_1 (win_fft_cen_1)
    , .cen_2 (win_fft_cen_2)
    , .q_1 (win_fft_data_out_1)
    , .q_2 (win_fft_data_out_2)
    , .wen_1 (win_fft_wen_1)
    , .wen_2 (win_fft_wen_2)
    , .addr_1 (win_fft_addr_1)
    , .addr_2 (win_fft_addr_2)
    , .data_out (fft_data_in)
      );

memory win_fft_mem_01 (
      .clk (clk)
    , .cen (win_fft_cen_1)
    , .wen (win_fft_wen_1)
    , .addr (win_fft_addr_1)
    , .data (window_data_out)
    , .q (win_fft_data_out_1)
         );

memory win_fft_mem_02 (
      .clk (clk)
    , .cen (win_fft_cen_2)
    , .wen (win_fft_wen_2)
    , .addr (win_fft_addr_2)
    , .data (window_data_out)
    , .q (win_fft_data_out_2)
         );

//=============   FFT   ==============================


top_fft fft_01 (
                 .clk (clk)
               , .rst_n (rst_n)
               , .ena_fft (fft_state_en)
               , .data_rd_int_01 (data_rd_int_01)
               , .data_rd_int_02 (data_rd_int_02)
               , .data_rd_int_03 (data_rd_int_03) // real
               , .data_rd_int_04 (data_rd_int_04)
               , .data_rd_int_05 (data_rd_int_05)
               , .data_rd_int_06 (data_rd_int_06) // image
               , .data_w_real (fft_real_w_data)
               , .data_w_image (fft_image_w_data)
               , .wr_ena_int_01 (wr_ena_int_01)        
               , .wr_ena_int_02 (wr_ena_int_02)
               , .wr_ena_int_03 (write_fft_real_en)
               , .wr_ena_int_04 (wr_ena_int_04)
               , .wr_ena_int_05 (wr_ena_int_05)
               , .wr_ena_int_06 (write_fft_image_en)
               , .addr_mem_int_01 (addr_mem_int_01)
               , .addr_mem_int_02 (addr_mem_int_02)
               , .addr_mem_int_03 (fft_real_mem_write_addr)
               , .addr_mem_int_04 (addr_mem_int_04)
               , .addr_mem_int_05 (addr_mem_int_05)
               , .addr_mem_int_06 (fft_image_mem_write_addr)
               , .addr_input (fft_mem_read_addr)
               , .addr_w (fft_w_addr)
               , .data_wr_int_01 (data_wr_int_01)
               , .data_wr_int_02 (data_wr_int_02)
               , .data_wr_int_03 (data_wr_int_03)
               , .data_wr_int_04 (data_wr_int_04)
               , .data_wr_int_05 (data_wr_int_05)
               , .data_wr_int_06 (data_wr_int_06)
               , .data_input (fft_data_in)
               , .stage_number (fft_stage_number) 
               , .max_point_fft (fft_num)
               , .max_point_fft_core (max_point_fft_core) // max_point_fft_core = (fft_num * 10) + 30 
               );


one_mem_cof_ctrl w_real_cof_ctrl (
          .system_sel (system_w_real_cof_sel)
        , .cen_in (system_w_real_cof_cen)
        , .read_wen (1'b1)
        , .system_wen (system_w_real_cof_wen)
        , .read_addr (fft_w_addr)
        , .system_addr (system_w_real_cof_addr)
        , .write_data_in (system_write_w_real_cof_data_in)
        , .cen_out (w_real_cen)
        , .wen_out (w_real_wen)
        , .addr_out (fft_w_real_addr_out)
        , .write_data_out (system_write_w_real_cof_data_out)
        );

mem_w_real w_real_mem_01 (
      .clk (clk)
    , .cen (w_real_cen)
    , .wen (w_real_wen)
    , .addr (fft_w_real_addr_out)
    , .data (system_write_w_real_cof_data_out)
    , .q (fft_real_w_data)
         );
 
one_mem_cof_ctrl w_image_cof_ctrl (
          .system_sel (system_w_image_cof_sel)
        , .cen_in (system_w_image_cof_cen)
        , .read_wen (1'b1)
        , .system_wen (system_w_image_cof_wen)
        , .read_addr (fft_w_addr)
        , .system_addr (system_w_image_cof_addr)
        , .write_data_in (system_write_w_image_cof_data_in)
        , .cen_out (w_image_cen)
        , .wen_out (w_image_wen)
        , .addr_out (fft_w_image_addr_out)
        , .write_data_out (system_write_w_image_cof_data_out)
        );

mem_w_image w_image_mem_01 (
      .clk (clk)
    , .cen (w_image_cen)
    , .wen (w_image_wen)
    , .addr (fft_w_image_addr_out)
    , .data (system_write_w_image_cof_data_out)
    , .q (fft_image_w_data)
         );

mem_fft_ctrl real_fft_amp_ctrl (
      .mem_sel (fft_amp_mem_sel)
    , .read_en (1'b0)
    , .write_en (write_fft_real_en)
    , .read_addr (amp_mem_read_addr)
    , .write_addr (fft_real_mem_write_addr)
    , .state_en_1 (fft_state_en)
    , .state_en_2 (amp_state_en)
    , .cen_1 (fft_amp_real_cen_1)
    , .cen_2 (fft_amp_real_cen_2)
    , .q_1 (fft_amp_real_data_out_1)
    , .q_2 (fft_amp_real_data_out_2)
    , .wen_1 (fft_amp_real_wen_1)
    , .wen_2 (fft_amp_real_wen_2)
    , .addr_1 (fft_amp_real_addr_1)
    , .addr_2 (fft_amp_real_addr_2)
    , .data_out (amp_real_data_in)
    , .data_int_out (data_rd_int_03)
      );

memory real_fft_amp_mem_01 (
      .clk (clk)
    , .cen (fft_amp_real_cen_1)
    , .wen (fft_amp_real_wen_1)
    , .addr (fft_amp_real_addr_1)
    , .data (data_wr_int_03)
    , .q (fft_amp_real_data_out_1)
         );

memory real_fft_amp_mem_02 (
      .clk (clk)
    , .cen (fft_amp_real_cen_2)
    , .wen (fft_amp_real_wen_2)
    , .addr (fft_amp_real_addr_2)
    , .data (data_wr_int_03)
    , .q (fft_amp_real_data_out_2)
         );


mem_fft_ctrl image_fft_amp_ctrl (
      .mem_sel (fft_amp_mem_sel)
    , .read_en (1'b0)
    , .write_en (write_fft_image_en)
    , .read_addr (amp_mem_read_addr)
    , .write_addr (fft_image_mem_write_addr)
    , .state_en_1 (fft_state_en)
    , .state_en_2 (amp_state_en)
    , .cen_1 (fft_amp_image_cen_1)
    , .cen_2 (fft_amp_image_cen_2)
    , .q_1 (fft_amp_image_data_out_1)
    , .q_2 (fft_amp_image_data_out_2)
    , .wen_1 (fft_amp_image_wen_1)
    , .wen_2 (fft_amp_image_wen_2)
    , .addr_1 (fft_amp_image_addr_1)
    , .addr_2 (fft_amp_image_addr_2)
    , .data_out (amp_image_data_in)
    , .data_int_out (data_rd_int_06)
      );

memory image_fft_amp_mem_01 (
      .clk (clk)
    , .cen (fft_amp_image_cen_1)
    , .wen (fft_amp_image_wen_1)
    , .addr (fft_amp_image_addr_1)
    , .data (data_wr_int_06)
    , .q (fft_amp_image_data_out_1)
         );

memory image_fft_amp_mem_02 (
      .clk (clk)
    , .cen (fft_amp_image_cen_2)
    , .wen (fft_amp_image_wen_2)
    , .addr (fft_amp_image_addr_2)
    , .data (data_wr_int_06)
    , .q (fft_amp_image_data_out_2)
         );

memory fft_mem_int_01 (
      .clk (clk)
    , .cen (1'b1)
    , .wen (wr_ena_int_01)
    , .addr (addr_mem_int_01)
    , .data (data_wr_int_01)
    , .q (data_rd_int_01)
         );

memory fft_mem_int_02 (
      .clk (clk)
    , .cen (1'b1)
    , .wen (wr_ena_int_02)
    , .addr (addr_mem_int_02)
    , .data (data_wr_int_02)
    , .q (data_rd_int_02)
         );

memory fft_mem_int_04 (
      .clk (clk)
    , .cen (1'b1)
    , .wen (wr_ena_int_04)
    , .addr (addr_mem_int_04)
    , .data (data_wr_int_04)
    , .q (data_rd_int_04)
         ); 

memory fft_mem_int_05 (
      .clk (clk)
    , .cen (1'b1)
    , .wen (wr_ena_int_05)
    , .addr (addr_mem_int_05)
    , .data (data_wr_int_05)
    , .q (data_rd_int_05)
         );

//=============   Amplitude   =======================

amplitude amplitude_01 (
      .clk (clk)
    , .rst_n (rst_n)
    , .ampli_state_en (amp_state_en)
    , .quarter (quarter)      
    , .fft_num (fft_num) 
    , .fft_real_data_in (amp_real_data_in)
    , .fft_image_data_in (amp_image_data_in)
    , .ampli_mem_write_addr (amp_mem_write_addr)
    , .ampli_data_out (amp_data_out)
    , .ampli_mem_read_addr (amp_mem_read_addr)
    , .write_ampli_data_en (write_amp_en) 
          );


mem_ctrl amp_mel_ctrl (
      .mem_sel (amp_mel_mem_sel)
    , .read_en (1'b0)
    , .write_en (write_amp_en)
    , .read_addr (mel_mem_read_addr)
    , .write_addr (amp_mem_write_addr)
    , .state_en_1 (amp_state_en)
    , .state_en_2 (mel_state_en)
    , .cen_1 (amp_mel_cen_1)
    , .cen_2 (amp_mel_cen_2)
    , .q_1 (amp_mel_data_out_1)
    , .q_2 (amp_mel_data_out_2)
    , .wen_1 (amp_mel_wen_1)
    , .wen_2 (amp_mel_wen_2)
    , .addr_1 (amp_mel_addr_1)
    , .addr_2 (amp_mel_addr_2)
    , .data_out (mel_data_in)
      );

memory amp_mel_mem_01 (
      .clk (clk)
    , .cen (amp_mel_cen_1)
    , .wen (amp_mel_wen_1)
    , .addr (amp_mel_addr_1)
    , .data (amp_data_out)
    , .q (amp_mel_data_out_1)
         );

memory amp_mel_mem_02 (
      .clk (clk)
    , .cen (amp_mel_cen_2)
    , .wen (amp_mel_wen_2)
    , .addr (amp_mel_addr_2)
    , .data (amp_data_out)
    , .q (amp_mel_data_out_2)
         );
//==============   Mel   ============================
 mel mel_unit_05 (
      .clk (clk)
    , .rst_n (rst_n)
    , .mel_state_en (mel_state_en)
    , .mel_num (mel_num)
    , .fft_num (fft_num)
    , .mel_data_in (mel_data_in)
    , .mel_cof_in (mel_cof_in)
    , .mel_cof_read_addr (mel_cof_read_addr)
    , .mel_mem_write_addr (mel_mem_write_addr)
    , .mel_mem_read_addr (mel_mem_read_addr)
    , .mel_data_out (mel_data_out)
    , .write_mel_en (write_mel_en)
    , .exp_data_out (mel_exp_data_out)
    , .man_data_out (mel_man_data_out)
    , .exp_addr (mel_exp_addr)
    , .man_addr (mel_man_addr)

              );


mem_exponent mem_exponent_02 (.clk(clk)
                             ,.addr(mel_exp_addr)
                             ,.cen(system_mel_exp_cen)
                             ,.wen(system_mel_exp_wen)
                             ,.data(system_mel_exp_data_in)
                             ,.q(mel_exp_data_out)
                             );

mem_mantissa mem_mantissa_02 (.clk(clk)
                             ,.addr(mel_man_addr)
                             ,.cen(system_mel_man_cen)
                             ,.wen(system_mel_man_wen)
                             ,.data(system_mel_man_data_in)
                             ,.q(mel_man_data_out)
                             );

eight_mem_cof_ctrl mel_cof_mem_05 (
        .clk (clk)
      , .rst_n (rst_n)
      , .addr_8_mem_in (mel_cof_read_addr)
      , .system_8_mem_addr (system_8_mem_addr)
      , .q_0 (mel_cof_q_0)
      , .q_1 (mel_cof_q_1)
      , .q_2 (mel_cof_q_2)
      , .q_3 (mel_cof_q_3)
      , .q_4 (mel_cof_q_4)
      , .q_5 (mel_cof_q_5)
      , .q_6 (mel_cof_q_6)
      , .q_7 (mel_cof_q_7)
      , .system_8_mem_cen_sel (system_8_mem_cen_sel)
      , .system_8_mem_addr_sel (system_8_mem_addr_sel)
      , .system_8_mem_wen_in (system_8_mem_wen_in)
      , .system_8_mem_wen_out (mel_cof_wen_out)
      , .cen_0 (mel_cof_cen_0)
      , .cen_1 (mel_cof_cen_1)
      , .cen_2 (mel_cof_cen_2)
      , .cen_3 (mel_cof_cen_3)
      , .cen_4 (mel_cof_cen_4)
      , .cen_5 (mel_cof_cen_5)
      , .cen_6 (mel_cof_cen_6)
      , .cen_7 (mel_cof_cen_7)
      , .addr_8_mem_out (mel_cof_addr_out)
      , .data_8_mem_out (mel_cof_in)
          );

mem_mel_cof_0 mel_mem_cof_0 (
      .clk (clk)
    , .cen (mel_cof_cen_0)
    , .wen (mel_cof_wen_out)
    , .addr (mel_cof_addr_out)
    , .data (system_mel_cof_write_data)
    , .q (mel_cof_q_0)
         );

mem_mel_cof_1 mel_mem_cof_1 (
      .clk (clk)
    , .cen (mel_cof_cen_1)
    , .wen (mel_cof_wen_out)
    , .addr (mel_cof_addr_out)
    , .data (system_mel_cof_write_data)
    , .q (mel_cof_q_1)
         );

mem_mel_cof_2 mel_mem_cof_2 (
      .clk (clk)
    , .cen (mel_cof_cen_2)
    , .wen (mel_cof_wen_out)
    , .addr (mel_cof_addr_out)
    , .data (system_mel_cof_write_data)
    , .q (mel_cof_q_2)
         );

mem_mel_cof_3 mel_mem_cof_3 (
      .clk (clk)
    , .cen (mel_cof_cen_3)
    , .wen (mel_cof_wen_out)
    , .addr (mel_cof_addr_out)
    , .data (system_mel_cof_write_data)
    , .q (mel_cof_q_3)
         );


mem_mel_cof_4 mel_mem_cof_4 (
      .clk (clk)
    , .cen (mel_cof_cen_4)
    , .wen (mel_cof_wen_out)
    , .addr (mel_cof_addr_out)
    , .data (system_mel_cof_write_data)
    , .q (mel_cof_q_4)
         );

mem_mel_cof_5 mel_mem_cof_5 (
      .clk (clk)
    , .cen (mel_cof_cen_5)
    , .wen (mel_cof_wen_out)
    , .addr (mel_cof_addr_out)
    , .data (system_mel_cof_write_data)
    , .q (mel_cof_q_5)
         );

mem_mel_cof_6 mel_mem_cof_6 (
      .clk (clk)
    , .cen (mel_cof_cen_6)
    , .wen (mel_cof_wen_out)
    , .addr (mel_cof_addr_out)
    , .data (system_mel_cof_write_data)
    , .q (mel_cof_q_6)
         );

mem_mel_cof_7 mel_mem_cof_7 (
      .clk (clk)
    , .cen (mel_cof_cen_7)
    , .wen (mel_cof_wen_out)
    , .addr (mel_cof_addr_out)
    , .data (system_mel_cof_write_data)
    , .q (mel_cof_q_7)
         );

mem_ctrl mel_cep_ctrl (
      .mem_sel (mel_cep_mem_sel)
    , .read_en (1'b0)
    , .write_en (write_mel_en)
    , .read_addr (cep_mem_read_addr)
    , .write_addr (mel_mem_write_addr)
    , .state_en_1 (mel_state_en)
    , .state_en_2 (cep_state_en)
    , .cen_1 (mel_cep_cen_1)
    , .cen_2 (mel_cep_cen_2)
    , .q_1 (mel_cep_data_out_1)
    , .q_2 (mel_cep_data_out_2)
    , .wen_1 (mel_cep_wen_1)
    , .wen_2 (mel_cep_wen_2)
    , .addr_1 (mel_cep_addr_1)
    , .addr_2 (mel_cep_addr_2)
    , .data_out (cep_data_in)
      );

memory mel_cep_mem_01 (
      .clk (clk)
    , .cen (mel_cep_cen_1)
    , .wen (mel_cep_wen_1)
    , .addr (mel_cep_addr_1)
    , .data (mel_data_out)
    , .q (mel_cep_data_out_1)
         );

memory mel_cep_mem_02 (
       .clk (clk)
     , .cen (mel_cep_cen_2)
     , .wen (mel_cep_wen_2)
     , .addr (mel_cep_addr_2)
     , .data (mel_data_out)
     , .q (mel_cep_data_out_2)
          );

//===========   Ceptrum    ========================

cep cep_unit_06 (
     .clk (clk)
   , .rst_n (rst_n)
   , .cep_state_en (cep_state_en)
   , .cep_num (cep_num)
   , .mel_num (mel_num)
   , .cep_data_in (cep_data_in)
   , .cep_cof_in (cep_cof_in)
   , .cep_cof_read_addr (cep_cof_read_addr)
   , .cep_mem_write_addr (cep_mem_write_addr)
   , .cep_mem_read_addr (cep_mem_read_addr)
   , .cep_data_out (cep_data_out)
   , .write_cep_en (write_cep_en)
              );

one_mem_cof_ctrl cep_cof_ctrl (
          .system_sel (system_cep_cof_sel)
        , .cen_in (system_cep_cof_cen)
        , .read_wen (1'b1)
        , .system_wen (system_cep_cof_wen)
        , .read_addr (cep_cof_read_addr)
        , .system_addr (system_cep_cof_addr)
        , .write_data_in (system_write_cep_cof_data_in)
        , .cen_out (cep_cof_cen)
        , .wen_out (cep_cof_wen)
        , .addr_out (cep_cof_addr_out)
        , .write_data_out (system_write_cep_cof_data_out)
        );

mem_cepstral_cof cep_cof_mem_01 (
      .clk (clk)
    , .cen (cep_cof_cen)
    , .wen (cep_cof_wen)
    , .addr (cep_cof_addr_out)
    , .data (system_write_cep_cof_data_out)
    , .q (cep_cof_in)
         );
// copy_energy to result mem


copy_energy copy_energy_01 (
      .clk (clk)
    , .rst_n (rst_n)
    , .copy_energy_en (copy_energy_en)
    , .frame_num (frame_num)
    , .energy_mem_read_addr (energy_mem_read_addr)
    , .energy_mem_write_addr (energy_mem_write_addr)
    , .write_energy_to_result_en (write_energy_to_result_en)
            );

// Delta


delta delta_unit (
       .clk (clk)
     , .rst_n (rst_n)
     , .delta_state_en (delta_state_en)
     , .delta_data_in (result_data_out)
     , .frame_num (frame_num)
     , .cep_num (cep_num)
     , .delta_mem_read_write_addr (delta_mem_read_write_addr)
     , .write_delta_en (write_delta_en)
     , .delta_data_out (delta_data_out)
              );

// Delta_2nd

delta_2nd delta_2nd_unit (
       .clk (clk)
     , .rst_n (rst_n)
     , .delta_2nd_state_en (delta_2nd_state_en)
     , .delta_2nd_data_in (result_data_out)
     , .frame_num (frame_num)
     , .cep_num (cep_num)
     , .delta_2nd_mem_read_write_addr (delta_2nd_mem_read_write_addr)
     , .write_delta_2nd_en (write_delta_2nd_en)
     , .delta_2nd_data_out (delta_2nd_data_out)
              );

// 4 result memory

// them day dieu khien chon write_addr hay read_addr chp delta


result_addr_decoder result_addr_decoder_01 (
       .addr_0 (14'd0)
     , .addr_1 (energy_mem_write_addr)
     , .addr_2 (cep_mem_write_addr)
     , .addr_3 (delta_mem_read_write_addr)
     , .addr_4 (delta_2nd_mem_read_write_addr)
     , .wen_0 (1'b0)
     , .wen_1 (write_energy_to_result_en)
     , .wen_2 (write_cep_en)
     , .wen_3 (write_delta_en)
     , .wen_4 (write_delta_2nd_en)
     , .data_0 (32'd0)
     , .data_1 (result_energy_data_out)
     , .data_2 (cep_data_out)
     , .data_3 (delta_data_out)
     , .data_4 (delta_2nd_data_out)
     , .addr_sel (result_change_mem)
     , .addr_out (result_addr_in)
     , .wen_out (result_wen_out)
     , .data_out (result_write_data)
         );


four_mem_result_ctrl result_mem_ctrl (
        .clk (clk)
      , .rst_n (rst_n)
      , .addr_4_mem_in (result_addr_in)
      , .system_4_mem_addr (system_result_4_mem_addr)
      , .q_0 (result_q_0)
      , .q_1 (result_q_1)
      , .q_2 (result_q_2)
      , .q_3 (result_q_3)
      , .system_4_mem_cen_sel (system_result_4_mem_cen_sel)
      , .system_4_mem_addr_sel (system_result_4_mem_addr_sel)
      , .system_4_mem_wen_in (system_result_4_mem_wen_in)
      , .result_4_mem_wen_in (result_wen_out)
      , .result_4_mem_wen_out (result_4_mem_wen_out)
      , .cen_0 (result_cen_0)
      , .cen_1 (result_cen_1)
      , .cen_2 (result_cen_2)
      , .cen_3 (result_cen_3)
      , .addr_4_mem_out (result_addr_out)
      , .data_4_mem_out (result_data_out)
          );

memory result_mem_00 (
      .clk (clk)
    , .cen (result_cen_0)
    , .wen (result_4_mem_wen_out)
    , .addr (result_addr_out)
    , .data (result_write_data)
    , .q (result_q_0)
         );

memory result_mem_01 (
      .clk (clk)
    , .cen (result_cen_1)
    , .wen (result_4_mem_wen_out)
    , .addr (result_addr_out)
    , .data (result_write_data)
    , .q (result_q_1)
         );

memory result_mem_02(
      .clk (clk)
    , .cen (result_cen_2)
    , .wen (result_4_mem_wen_out)
    , .addr (result_addr_out)
    , .data (result_write_data)
    , .q (result_q_2)
         );

memory result_mem_03 (
      .clk (clk)
    , .cen (result_cen_3)
    , .wen (result_4_mem_wen_out)
    , .addr (result_addr_out)
    , .data (result_write_data)
    , .q (result_q_3)
         );

 endmodule
