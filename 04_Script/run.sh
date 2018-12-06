cp ./input_nochange/* ./input

input_file_window=window_cof.txt
output_file_window=mem_window_cof.v

input_file_w_real_fft=mem_w_real.txt
output_file_w_real_fft=mem_w_real.v

input_file_w_image_fft=mem_w_image.txt
output_file_w_image_fft=mem_w_image.v

input_file_cepstral=cepstral_cof.txt
output_file_cepstral=mem_cepstral_cof.v

input_file_input_data=input_data.txt
output_file_input_data=mem_input_data.v

input_file_exponent=exponent_software.txt
output_file_exponent=mem_exponent.v

input_file_mantissa=mantissa_software.txt
output_file_mantissa=mem_mantissa.v

input_file_mem_mel_cof_0=mem_cof_0.txt
output_file_mem_mel_cof_0=mem_mel_cof_0.v

input_file_mem_mel_cof_1=mem_cof_1.txt
output_file_mem_mel_cof_1=mem_mel_cof_1.v

input_file_mem_mel_cof_2=mem_cof_2.txt
output_file_mem_mel_cof_2=mem_mel_cof_2.v


input_file_mem_mel_cof_3=mem_cof_3.txt
output_file_mem_mel_cof_3=mem_mel_cof_3.v


input_file_mem_mel_cof_4=mem_cof_4.txt
output_file_mem_mel_cof_4=mem_mel_cof_4.v

input_file_mem_mel_cof_5=mem_cof_5.txt
output_file_mem_mel_cof_5=mem_mel_cof_5.v

input_file_mem_mel_cof_6=mem_cof_6.txt
output_file_mem_mel_cof_6=mem_mel_cof_6.v


input_file_mem_mel_cof_7=mem_cof_7.txt
output_file_mem_mel_cof_7=mem_mel_cof_7.v


echo "$input_file_window"
echo "$output_file_window"

echo "$input_file_w_real_fft"
echo "$output_file_w_real_fft"

echo "$input_file_w_image_fft"
echo "$output_file_w_image_fft"

echo "$input_file_cepstral"
echo "$output_file_cepstral"

echo "$input_file_input_data"
echo "$output_file_input_data"

echo "$input_file_exponent"
echo "$output_file_exponent"
echo "$input_file_mantissa"
echo "$output_file_mantissa"

echo "$input_file_mem_mel_cof_0"
echo "$output_file_mem_mel_cof_0"

echo "$input_file_mem_mel_cof_1"
echo "$output_file_mem_mel_cof_1"

echo "$input_file_mem_mel_cof_2"
echo "$output_file_mem_mel_cof_2"

echo "$input_file_mem_mel_cof_3"
echo "$output_file_mem_mel_cof_3"

echo "$input_file_mem_mel_cof_4"
echo "$output_file_mem_mel_cof_4"

echo "$input_file_mem_mel_cof_5"
echo "$output_file_mem_mel_cof_5"

echo "$input_file_mem_mel_cof_6"
echo "$output_file_mem_mel_cof_6"

echo "$input_file_mem_mel_cof_7"
echo "$output_file_mem_mel_cof_7"




/usr/bin/perl gen_mem_window_cof.pl $input_file_window $output_file_window 

/usr/bin/perl gen_mem_w_real.pl $input_file_w_real_fft $output_file_w_real_fft 

/usr/bin/perl gen_mem_w_image.pl $input_file_w_image_fft $output_file_w_image_fft 

/usr/bin/perl gen_mem_cepstral_cof.pl $input_file_cepstral $output_file_cepstral

/usr/bin/perl gen_mem_input_data.pl $input_file_input_data $output_file_input_data

/usr/bin/perl gen_mem_exponent.pl $input_file_exponent $output_file_exponent

/usr/bin/perl gen_mem_mantissa.pl $input_file_mantissa $output_file_mantissa

/usr/bin/perl gen_mem_mel_cof_0.pl $input_file_mem_mel_cof_0 $output_file_mem_mel_cof_0

/usr/bin/perl gen_mem_mel_cof_1.pl $input_file_mem_mel_cof_1 $output_file_mem_mel_cof_1

/usr/bin/perl gen_mem_mel_cof_2.pl $input_file_mem_mel_cof_2 $output_file_mem_mel_cof_2

/usr/bin/perl gen_mem_mel_cof_3.pl $input_file_mem_mel_cof_3 $output_file_mem_mel_cof_3

/usr/bin/perl gen_mem_mel_cof_4.pl $input_file_mem_mel_cof_4 $output_file_mem_mel_cof_4

/usr/bin/perl gen_mem_mel_cof_5.pl $input_file_mem_mel_cof_5 $output_file_mem_mel_cof_5

/usr/bin/perl gen_mem_mel_cof_6.pl $input_file_mem_mel_cof_6 $output_file_mem_mel_cof_6

/usr/bin/perl gen_mem_mel_cof_7.pl $input_file_mem_mel_cof_7 $output_file_mem_mel_cof_7
