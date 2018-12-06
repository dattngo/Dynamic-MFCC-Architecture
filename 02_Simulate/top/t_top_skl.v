module t_top;
 
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 12;
parameter COUNTER_VALUE_WIDTH = 8;

reg clk, rst_n;
reg top_state_en;
reg [6:0] frame_num;
reg [10:0] sample_in_frame;
reg [ADDR_WIDTH-1 : 0] com_2_ovl;
reg [15:0] max_point_fft_core;
reg [DATA_WIDTH-1 : 0] alpha, quarter;
reg [11:0] fft_num;
reg [3:0] fft_stage_number;
reg [5:0] mel_num;
reg [6:0] cep_num;

reg [7:0] i;
reg [7:0] j;

wire [DATA_WIDTH-1 : 0] result_data_out;
wire finish_flag;

reg [13:0] system_result_4_mem_addr;
reg system_result_4_mem_cen_sel, system_result_4_mem_addr_sel, system_result_4_mem_wen_in;

integer output_file_preem, output_file_win, output_file_fft_real, output_file_fft_image, output_file_amp, output_file_mel, output_file_cep, output_file_log, output_file_delta, output_file_delta_2nd, output_file_result;


always  begin
  clk = 1'b0;
  #5 clk = 1'b1;
  #5;
end

initial begin
  rst_n = 1'b1;
  #10 rst_n = 1'b0;
  #22 rst_n = 1'b1;
  #320000000;
  $finish;
end

initial begin
    //frame_num = 8'd24;         //So frame --> Software cung cung
    //sample_in_frame = 11'd320; //So diem tren mot frame
    //com_2_ovl = 12'hf60;       //Bu 2 de dich ve phuc vu cho overlap
    //alpha = 32'hbf7851ec;      //Gia tri anpha trong bo preemphasis
    //fft_num = 11'd512;         //So fft 
    //fft_stage_number = 4'd9;   //So tang tinh FFT
    //mel_num = 6'd63;           //So bo loc Mel
    //cep_num = 6'd31;           //So cepstrum 
    //quarter = 32'h3e800000;    //Do chinh xac khoi bien do
    //max_point_fft_core = 16'd5150; //So 

    DEFINE_FRAME_NUM 
    DEFINE_SAMPLE_IN_FRAME 
    DEFINE_COM_2_OVL 
    DEFINE_ALPHA 
    DEFINE_FFT_NUM 
    DEFINE_FFT_STAGE_NUMBER 
    DEFINE_MEL_NUM 
    DEFINE_CEP_NUM 
    DEFINE_QUARTER 
    DEFINE_MAX_POINT_FFT_CORE 
    
    
    #5;
    top_state_en = 1;          //Trigger MFCC chay
    #100;
    top_state_en = 0;
end  

top top_01 (
     .clk (clk)
   , .rst_n (rst_n)
   , .top_state_en (top_state_en)
   , .frame_num (frame_num)
   , .sample_in_frame (sample_in_frame)
   , .com_2_ovl (com_2_ovl)
   , .alpha (alpha)
   , .quarter (quarter)
   , .fft_num (fft_num)
   , .fft_stage_number (fft_stage_number)
   , .mel_num (mel_num)
   , .cep_num (cep_num)
   , .max_point_fft_core (max_point_fft_core)
   , .system_voice_sel (1'b1)
   , .system_voice_cen (1'b1)
   , .system_voice_wen (1'b1)
   , .system_voice_addr (12'd0)
   , .system_voice_write_data_in (32'd0)
   , .system_win_cof_addr (12'd0)
   , .system_win_cof_sel (1'b1)
   , .system_win_cof_cen (1'b1)
   , .system_win_cof_wen (1'b1)
   , .system_write_win_cof_data_in (32'd0)
   , .system_w_real_cof_sel (1'b1)
   , .system_w_real_cof_cen (1'b1)
   , .system_w_real_cof_wen (1'b1)
   , .system_w_real_cof_addr (12'd0)
   , .system_write_w_real_cof_data_in (32'd0)
   , .system_w_image_cof_sel (1'b1)
   , .system_w_image_cof_cen (1'b1)
   , .system_w_image_cof_wen (1'b1)
   , .system_w_image_cof_addr (12'd0)
   , .system_write_w_image_cof_data_in (32'd0)
   , .system_8_mem_cen_sel (1'b1)
   , .system_8_mem_wen_in (1'b1)
   , .system_8_mem_addr (15'd0)
   , .system_8_mem_addr_sel (1'b1)
   , .system_write_cep_cof_data_in (32'd0)
   , .system_cep_cof_sel (1'b1)
   , .system_cep_cof_cen (1'b1)
   , .system_cep_cof_wen (1'b1)
   , .system_cep_cof_addr (12'd0)
   , .system_energy_log_cen (1'b1)
   , .system_mel_cof_write_data (32'd0)
   , .system_result_4_mem_addr (system_result_4_mem_addr)
   , .system_result_4_mem_cen_sel (system_result_4_mem_cen_sel)
   , .system_result_4_mem_addr_sel (system_result_4_mem_addr_sel)
   , .system_result_4_mem_wen_in (system_result_4_mem_wen_in)
   , .system_preem_exp_cen (1'b1)
   , .system_preem_exp_wen (1'b0)
   , .system_preem_man_cen (1'b1)
   , .system_preem_man_wen (1'b0)
   , .system_preem_exp_data_in (32'd0)
   , .system_preem_man_data_in (32'd0)
   , .system_mel_exp_cen (1'b1)
   , .system_mel_exp_wen (1'b0)
   , .system_mel_man_cen (1'b1)
   , .system_mel_man_wen (1'b0)
   , .system_mel_exp_data_in (32'd0)
   , .system_mel_man_data_in (32'd0)
   , .result_data_out (result_data_out)
   , .finish_flag (finish_flag)
       );



initial begin
  output_file_preem = $fopen ("output_file_preem.txt");
  output_file_win = $fopen ("output_file_win.txt");
  output_file_fft_real = $fopen ("output_file_fft_real.txt");
  output_file_fft_image = $fopen ("output_file_fft_image.txt");
  output_file_amp = $fopen ("output_file_amp.txt");
  output_file_mel = $fopen ("output_file_mel.txt");
  output_file_cep = $fopen ("output_file_cep.txt");
  output_file_log = $fopen ("output_file_log.txt");
  output_file_delta = $fopen ("output_file_delta.txt");
  output_file_delta_2nd = $fopen ("output_file_delta_2nd.txt");
  output_file_result = $fopen ("output_file_result.txt");
end

always@(posedge top_01.write_preem_en) begin
    $fdisplayh (output_file_preem, top_01.preem_data_out);
end

always@(posedge top_01.write_win_en) begin
    $fdisplayh (output_file_win, top_01.window_data_out);
end

// Dat, you write the conditions of fft_output in always loop to extract the output data
// The output data must be different from the data used for calculating intermediate values

always@(posedge top_01.write_fft_real_en) begin
    $fdisplayh (output_file_fft_real, top_01.data_wr_int_03);
end

always@(posedge top_01.write_fft_image_en) begin
    $fdisplayh (output_file_fft_image, top_01.data_wr_int_06);
end

always@(posedge top_01.write_amp_en) begin
    $fdisplayh (output_file_amp, top_01.amp_data_out);
end

always@(posedge top_01.write_mel_en) begin
    $fdisplayh (output_file_mel, top_01.mel_data_out);
end

always@(posedge top_01.write_cep_en) begin
    $fdisplayh (output_file_cep, top_01.cep_data_out);
end

always@(posedge top_01.write_delta_en) begin
    $fdisplayh (output_file_delta, top_01.delta_data_out);
end

always@(posedge top_01.write_delta_2nd_en) begin
    $fdisplayh (output_file_delta_2nd, top_01.delta_2nd_data_out);
end

always@(posedge top_01.write_energy_to_result_en) begin
    $fdisplayh (output_file_log, top_01.result_energy_data_out);
end

initial begin
    system_result_4_mem_addr = 14'd0;
    system_result_4_mem_cen_sel = 1'b1;
    system_result_4_mem_addr_sel = 1'b1;
    system_result_4_mem_wen_in = 1'b0;
    
    @(posedge top_01.finish_flag);
    #15;
    
    system_result_4_mem_addr_sel = 1'b0;
     
    for (i = 2; i <= (frame_num - 3); i = i + 1) begin
        for (j = 0; j <= ((cep_num * 2) + 1); j = j + 1) begin
            system_result_4_mem_addr = {i [7:0], j [5:0]};
            #10;
            $fdisplayh (output_file_result, top_01.result_data_out);
            #5;
        end 
    end
end

initial begin
  $vcdplusfile ("top.pwd");
  $vcdpluson ();
end

endmodule
