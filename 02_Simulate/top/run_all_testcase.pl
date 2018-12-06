#!/usr/bin/perl
&main;
sub main {
    $case_num = 0;
    open ($CONFIG, "./config.txt") || die("There is no config file \n");
    foreach $line (<$CONFIG>){
        if( ($line !~ /^#/) or ($line !~ /^ *#/) ) {
            $case_num = $case_num + 1;
            chop($line);
            @line_mem =  split(/  */, $line); 

            $frame_num          = @line_mem[0];
            $sample_in_frame    = @line_mem[1];
            $com_2_ovl          = @line_mem[2];
            $alpha              = @line_mem[3];
            $fft_num            = @line_mem[4];
            $fft_stage_number   = @line_mem[5];
            $mel_num            = @line_mem[6];
            $cep_num            = @line_mem[7];
            $quarter            = @line_mem[8];
            $max_point_fft_core = @line_mem[9];
            printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX =========================== \n");
            printf("case $case_num CONFIG : $frame_num $sample_in_frame $com_2_ovl $alpha $fft_num $fft_stage_number $mel_num $cep_num $quarter $max_point_fft_core \n");

            #system("./gen_top.pl $frame_num  $sample_in_frame  $com_2_ovl $alpha  $fft_num  $fft_stage_number  $mel_num  $cep_num  $quarter  $max_point_fft_core ");

            open ($TOP_SKL,"./t_top_skl.v") || die("There is no config file \n");
            open ($TOP, ">./t_top.v");
            foreach $line (<$TOP_SKL>){
                if($line =~ /DEFINE_FRAME_NUM/){
                    printf $TOP ("frame_num = $frame_num; \n");
                
                }elsif($line =~ /DEFINE_SAMPLE_IN_FRAME/){
                    printf $TOP ("sample_in_frame = $sample_in_frame; \n");

                }elsif($line =~ /DEFINE_COM_2_OVL/){
                    printf $TOP ("com_2_ovl = $com_2_ovl; \n");

                }elsif($line =~ /DEFINE_ALPHA/){
                    printf $TOP ("alpha = $alpha; \n");

                }elsif($line =~ /DEFINE_FFT_NUM/){
                    printf $TOP ("fft_num = $fft_num; \n");

                }elsif($line =~ /DEFINE_FFT_STAGE_NUMBER/){
                    printf $TOP ("fft_stage_number = $fft_stage_number; \n");

                }elsif($line =~ /DEFINE_MEL_NUM/){
                    printf $TOP ("mel_num = $mel_num; \n");

                }elsif($line =~ /DEFINE_CEP_NUM/){
                    printf $TOP ("cep_num = $cep_num; \n");

                }elsif($line =~ /DEFINE_QUARTER/){
                    printf $TOP ("quarter = $quarter; \n");

                }elsif($line =~ /DEFINE_MAX_POINT_FFT_CORE/){
                    printf $TOP ("max_point_fft_core = $max_point_fft_core; \n");

                }else{
                    printf $TOP ("$line");
                }
            }
            close($TOP_SKL);
            close($TOP);
            system ("pwd"); # kiem tra duong dan
            system ("cp ./testcase/testcase_$case_num/*.txt ../../04_Script/input");
            system ("./run.sh");
            system ("rm -r ./FILE_REPORT/CONFIG_$case_num");
            system ("mkdir ./FILE_REPORT/CONFIG_$case_num");
            system ("pwd");
            system ("cp -rf ./run/*txt ./FILE_REPORT/CONFIG_$case_num/");
        }
    }
    close($CONFIG);
}
