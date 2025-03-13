module DSP_tb ();

parameter OPERATION = "ADD";

localparam ABD_INPUT_WIDTH = 18;
localparam ABD_Const_No = 100 * ABD_INPUT_WIDTH;
localparam C_INPUT_WIDTH = 48;
localparam C_Const_No = 100 * C_INPUT_WIDTH;
localparam ZERO = 0;

reg [ABD_INPUT_WIDTH - 1: 0] A, B, D;  
reg [C_INPUT_WIDTH - 1: 0] C;        
reg clk, rst_n;      
wire [47: 0] P;    

initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end

DSP #(.OPERATION(OPERATION)) DUT (A, B, C, D, clk, rst_n, P);

integer error_count; 
integer correct_count; 

initial begin
    error_count = 0;
    correct_count = 0;

    check_reset;

    A = ZERO; B = ZERO; C = ZERO; D = ZERO; 
    check_result(((D + B) * A) + C);
    A = {18{1'b1}}; B = ZERO; C = ZERO; D = ZERO; 
    check_result(((D + B) * A) + C);
    A = ZERO; B = {18{1'b1}}; C = ZERO; D = ZERO; 
    check_result(((D + B) * A) + C);
    A = ZERO; B = ZERO; C = {48{1'b1}}; D = ZERO; 
    check_result(((D + B) * A) + C);
    A = ZERO; B = ZERO; C = ZERO; D = {18{1'b1}}; 
    check_result(((D + B) * A) + C);
    A = {18{1'b1}}; B = ZERO; C = ZERO; D = {18{1'b1}}; 
    check_result(((D + B) * A) + C);
    A = ZERO; B = {18{1'b1}}; C = ZERO; D = {18{1'b1}}; 
    check_result(((D + B) * A) + C);
    A = ZERO; B = ZERO; C = ZERO; D = ZERO; 
    check_result(((D + B) * A) + C);
    
    A = ABD_Const_No; B = ABD_Const_No; C = C_Const_No; D = ZERO;
    check_result(((D + B) * A) + C);
    A = ABD_Const_No; B = ABD_Const_No; C = ZERO; D = ABD_Const_No;
    check_result(((D + B) * A) + C);
    A = ZERO; B = ABD_Const_No; C = C_Const_No; D = ZERO;
    check_result(((D + B) * A) + C);
    A = ZERO; B = ABD_Const_No; C = C_Const_No; D = ABD_Const_No;
    check_result(((D + B) * A) + C);
    A = ZERO; B = ZERO; C = C_Const_No; D = ABD_Const_No;
    check_result(((D + B) * A) + C);

    for (int i = 0; i < 100; i = i + 1) begin
        A = $urandom_range(ZERO, ABD_Const_No);
        B = $urandom_range(ZERO, ABD_Const_No);
        C = $urandom_range(ZERO, C_Const_No);
        D = $urandom_range(ZERO, ABD_Const_No);
        check_result(((D + B) * A) + C);
    end

    check_reset;

    $display("%0t: At End of test error counter = %0d and correct counter = %0d", $time, error_count, correct_count);
    $stop;
end

task check_result (input [47: 0] expected_result);
    repeat(4) @(negedge clk);
    if (P != expected_result) begin
        error_count = error_count + 1;
        $display("%0t: Error: For A = %0d, B = %0d, C = %0d, D = %0d and P should be equal to %0d but it is equal %0d", $time, A, B, C, D, expected_result, P);
    end else begin
        correct_count = correct_count + 1;
    end
endtask

task check_reset();
    rst_n = 0;
    @(negedge clk);
    if (P != 0) begin
        error_count = error_count + 1;
        $display("%0t: Error: Reset Value is Asserted and the Output is Not Tied to Low", $time);
    end else begin
        correct_count = correct_count + 1;
    end
    rst_n = 1;
endtask

endmodule
