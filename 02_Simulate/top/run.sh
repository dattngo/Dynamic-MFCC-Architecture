cd ./../../04_Script 
./run.sh
pwd 
cp -rf ./output/*.v  ./../01_Design/00_Coefficients
cd ./../02_Simulate/top
pwd 

cp -rf ./../../01_Design/top/*.v ./run
cp -rf ./../../01_Design/top_ctrl/*.v ./run
cp -rf ./../../01_Design/00_Common/*.v ./run
cp -rf ./../../01_Design/00_Coefficients/*.v ./run
cp -rf ./../../01_Design/01_Pre_emphasis/*.v ./run/
cp -rf ./../../01_Design/02_Window/*.v ./run/
cp -rf ./../../01_Design/03_FFT/*.v ./run/
cp -rf ./../../01_Design/04_Amplitude/*.v ./run/
cp -rf ./../../01_Design/05_Mel/*.v ./run/
cp -rf ./../../01_Design/06_Ceptrum/*.v ./run/
cp -rf ./../../01_Design/07_Delta/*.v ./run/
cp -rf ./../../01_Design/08_Delta_2nd/*.v ./run/
cp -rf ./t_top.v ./run
cd run
vcs +v2k -R -debug_all *.v | tee VCS_log.txt
#vcs +v2k -R *.v 
cd ..
