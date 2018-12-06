&main;
sub main {
    $INPUT_FILE      = $ARGV[0];
    $TARGET_FILE     = $ARGV[1];

    open ($MEM_CASE, "./input/$INPUT_FILE") || die("There is no skeleton file \n");
    open ($MEM_V, ">./output/$TARGET_FILE");
    
    printf $MEM_V ("module mem_mel_cof_6 (clk, addr, cen, wen, data, q);\n");
    printf $MEM_V ("parameter DATA_WIDTH =  32;\n");
    printf $MEM_V ("input clk;\n");
    printf $MEM_V ("input [11:0] addr;// Note\n");
    printf $MEM_V ("input cen;\n");
    printf $MEM_V ("input wen;\n");
    printf $MEM_V ("input [DATA_WIDTH-1:0]data;\n");
    printf $MEM_V ("output [DATA_WIDTH-1:0] q;\n");
    printf $MEM_V ("reg    [DATA_WIDTH-1:0] q;\n");
    printf $MEM_V ("always@(posedge clk) begin\n");
    printf $MEM_V ("    case(addr)\n");
    $count = -1;
    foreach $line (<$MEM_CASE>)
	{
	    chop($line);
	    $count = $count+1;
            printf $MEM_V ("        $count:  q   <=  32'b$line;\n");
   	 }
    printf $MEM_V ("        default: q <= 0;\n");
    printf $MEM_V ("    endcase\n");
    printf $MEM_V ("end\n");
    printf $MEM_V ("endmodule\n");
    close($INPUT_FILE);
    close($TARGET_FILE);
}
