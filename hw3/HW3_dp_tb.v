`include "HW3_dp.v"

module HW3_test_dp();

// Inputs
reg clk;
reg reset;
reg inputA;
// Outputs
wire dp_out;

integer i,j,outfile,pat_error;

reg[6:0] BIT_PATTERN_BASIC = 7'b1101101;
reg[11:0] BIT_PATTERN_OVER = 12'b110110110110;
reg[7:0] BIT_PATTERN_BEGIN_RESET = 8'b11101101;
reg[10:0] BIT_PATTERN_END_RESET = 11'b11011101101;

// Instantiate a Design Under Test (DUT)
HW3_dp dp_0(
    .i_clk    (   clk             ),
    .i_rst_n  (   reset           ),
    .i_data   (   inputA          ),
    .o_find   (   dp_out          ));

// Oscillate the clock (cycle time is 8ns)
always #4 clk = ~clk;

initial begin
    i = 0;

    $dumpfile("hw3_test_dp.vvp");
    $dumpvars(0, HW3_test_dp);
    outfile=$fopen("dp_out.txt");          //open one file for writing
    if(!outfile) begin
        $display("Cannot write file!");
        $finish;
    end

    pat_error=0;

    reset=1'b1;
    clk=1'b1;
    inputA=0;

    #2 reset=1'b0; // system reset
    #2 reset=1'b1;
    #4

    // Basic test. Should be evenly spaced apart
    for(j = 0; j < 28; j=j+1)
    begin
        inputA = BIT_PATTERN_BASIC[6 - (j%7)];
        #8;
        // We expect that every 7 inputs should trigger a match.
        if((j%7)==6)
        begin
            if(dp_out != 1'b1)
            begin
                $fdisplay(outfile,"Basic Test - Expected pattern match but missed for iteration: %d!",i);
                pat_error=pat_error+1;
            end
            i=i+1;
        end
    end
    #8


    #2 reset=1'b0; // system reset
    #2 reset=1'b1;
    #4

    // Overlapping pattern test. Getting fancier, expect matches every 3 after the first 7.
    i = 0;
    for(j = 0; j < 36; j=j+1)
    begin
        inputA = BIT_PATTERN_OVER[11 - (j%12)];
        #8;
        // Only the first match is delayed by 7
        if(i == 0)
        begin
            if((j%7)==6)
            begin
                if(dp_out != 1'b1)
                begin
                    $fdisplay(outfile,"Overlap Test - Expected pattern match but missed for iteration: %d!",i);
                    pat_error=pat_error+1;
                end
                i=i+1;
            end
        end
        // After the first iteration every match is delayed by 3 cycles due to overlap
        else
        begin
            if((j%3)==0)
            begin
                if(dp_out != 1'b1)
                begin
                    $fdisplay(outfile,"Overlap Test - Expected pattern match but missed for iteration: %d!",i);
                    pat_error=pat_error+1;
                end
                i=i+1;
            end
        end
    end
    #8

    #2 reset=1'b0; // system reset
    #2 reset=1'b1;
    #4

    // Beginning reset test. One match only when reaching the end!
    // Tests when the third state receives a one. Not a complete
    // stop but pushes match back one cycle
    i = 0;
    for(j = 0; j < 8; j=j+1)
    begin
        inputA = BIT_PATTERN_BEGIN_RESET[7 - j];
        #8;
        // We expect the 7th cycle to cause a match
        if(j==7)
        begin
            if(dp_out != 1'b1)
            begin
                $fdisplay(outfile,"Beginning Reset Test - Expected pattern match but missed for iteration: %d!",i);
                pat_error=pat_error+1;
            end
        end
    end
    #8

    #2 reset=1'b0; // system reset
    #2 reset=1'b1;
    #4

    // End reset test. One match only when reaching the end!
    // Tests when the sixth state receives a one. Not a complete
    // stop but pushes match back four cycles
    i = 0;
    for(j = 0; j < 11; j=j+1)
    begin
        inputA = BIT_PATTERN_END_RESET[10 - j];
        #8;
        // We expect the 13th cycle to cause a match
        if(j==10)
        begin
            if(dp_out != 1'b1)
            begin
                $fdisplay(outfile,"Beginning Reset Test - Expected pattern match but missed for iteration: %d!",i);
                pat_error=pat_error+1;
            end
        end
    end
    #8


     if(pat_error == 0)
       $display("\nCongratulations!! Your Verilog Code is correct!!\n");
     else
       $display("\nYour Verilog Code has %d errors. \nPlease read alu_out.txt for details.\n",pat_error);
  #10 $stop;



end

endmodule
