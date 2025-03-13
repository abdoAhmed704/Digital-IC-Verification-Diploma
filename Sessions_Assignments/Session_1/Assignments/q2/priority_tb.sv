module priority_enc_tb();

reg clk, rst;
reg [3:0] D;
wire [1:0] Y;
wire valid;


priority_enc pe(.*);


integer ErrorCount = 0, CorrectCount = 0;

initial begin
    clk = 0;
    forever
        #2 clk = ~clk;
end


initial begin
    D = 4'b0;
    assert_reset;

    D = 4'b1000;
    check_outputs(2'b0, 1);

    D = 4'b0100;
    check_outputs(2'b01, 1);
    D = 4'b1100;
    check_outputs(2'b01, 1);

    D = 4'b0010;
    check_outputs(2'b10, 1);
    D = 4'b1100;
    check_outputs(2'b01, 1);

    D = 4'b0110;
    check_outputs(2'b10, 1);
    D = 4'b1010;
    check_outputs(2'b10, 1);
    D = 4'b1110;

    check_outputs(2'b10, 1);
    D = 4'b0001;
    check_outputs(2'b11, 1);
    D = 4'b0011;
    check_outputs(2'b11, 1);
    D = 4'b0101;

    check_outputs(2'b11, 1);
    D = 4'b1001;
    check_outputs(2'b11, 1);
    D = 4'b1101;

    check_outputs(2'b11, 1);
    D = 4'b0111;
    check_outputs(2'b11, 1);
    D = 4'b1111;
    check_outputs(2'b11, 1);
    
    D = 4'b1011;
    check_outputs(2'b11, 1);
    D = 4'b0;
    check_outputs(2'bXX, 0);

    $display("Number of -correct checks = %0d, - Number of Errors = %0d", CorrectCount, ErrorCount);
    $stop;
end

task check_outputs(input [3:0] Y_expected, input valid_expected);
    @(negedge clk);
    if (Y != Y_expected && valid_expected != valid)begin
        $display("Error in Y_expected = %b, Y = %b, valid = %b, valid_ex = %b", Y_expected, Y, valid, valid_expected);
        ErrorCount++;
    end
    else begin
        CorrectCount++;
    end
endtask


task assert_reset;
    rst = 0;
    @(negedge clk);
    rst = 1;
    @(negedge clk);
    if (Y != 2'b0 && valid != 0)begin
        $display("Error in rst activation");
        ErrorCount++;
    end
    rst = 0;
endtask

endmodule