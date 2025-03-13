module adder_tb;
    reg clk, reset;
    reg signed [3:0] A;
    reg signed [3:0] B;

    wire signed [4:0] C;

    localparam MAXPOS = 7, ZERO = 0, MAXNEG = -8;

    int ErrorCount = 0;
    int CorrectCount = 0;

    adder a1(.*);
    initial begin
        clk = 0;
        forever
        #2 clk = ~clk;
    end

    initial begin
        A = 0;
        B = 0;
        assert_reset;
        assert_reset;
        A = MAXPOS; B = MAXPOS;
        check_result(14);

        A = MAXPOS; B = MAXNEG;
        check_result(-1);

        A = MAXNEG; B = MAXPOS;
        check_result(-1);
        
        A = MAXNEG; B = MAXNEG;
        check_result(-16);
    
        A = MAXPOS; B = ZERO;
        check_result(7);
        
        A = ZERO; B = MAXPOS;
        check_result(7);
        
        A = MAXNEG; B = ZERO;
        check_result(-8);
        
        A = ZERO; B = MAXNEG;
        check_result(-8);
        
        A = ZERO; B = ZERO;
        check_result(0);

        $display("%t: Errors = %0d, Corrects = %0d", $time ,  ErrorCount, CorrectCount);
        $stop;
    end


task assert_reset;
    // Toggle from 0 to 1
    reset = 0;
    @(negedge clk);
    reset = 1;  // This line explicitly creates a 0 -> 1 toggle
    @(negedge clk);

    // Check the reset functionality
    if (C != 5'b0) begin
        $display("Reset Error");
        ErrorCount++;
    end else
        CorrectCount++;
    
    // Toggle back to 0
    reset = 0;
endtask

task check_result(input signed [4:0] value);
    @(negedge clk);
    if (C !== value)begin
        $display("Error A = %0d, b = %0d, c = %0d, value = %0d", A, B, C, value);
        ErrorCount++;
    end
    else begin
        CorrectCount++;
    end
    reset = 0;
endtask


endmodule