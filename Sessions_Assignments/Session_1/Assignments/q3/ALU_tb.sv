module ALU_4_bit_tb;
reg clk;
reg reset;
reg [1:0] Opcode;	// The opcode
reg signed [3:0] A;	//data A in 2's complement
reg signed [3:0] B;	// Input data B in 2's complement
wire signed [4:0] C; // ALU output in 2's complement

localparam MAXPOS = 7, ZERO = 0, MAXNEG = -8;

int ErrorCount = 0;
int CorrectCount = 0;

ALU_4_bit alu4(.*);

initial begin
    clk = 0;

    forever begin
        #10 clk = ~clk; 
    end
end

initial begin
    A = 0;
    B = 0;
    Opcode = 0;
    assert_reset;
    Opcode_00;
    Opcode_01;
    Opcode_10;
    Opcode_11;

    //////// Just to make 100% Code coverage
    Opcode_00;
    ///////
    
    Opcode_xx;

    $display("corrects = %0d, Errors = %0d", CorrectCount, ErrorCount);
    $stop;
end

/////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////

task Opcode_00;
    Opcode = 2'b00;
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
endtask
//////////////////////////////////////////////////////////
task Opcode_01;
    Opcode = 2'b01;
    A = MAXPOS; B = MAXPOS;
    check_result(0);
    A = MAXPOS; B = MAXNEG;
    check_result(15);
    A = MAXNEG; B = MAXPOS;
    check_result(-15);
    A = MAXNEG; B = MAXNEG;
    check_result(0);
    A = MAXPOS; B = ZERO;
    check_result(7);
    A = ZERO; B = MAXPOS;
    check_result(-7);
    A = MAXNEG; B = ZERO;
    check_result(-8);
    A = ZERO; B = MAXNEG;
    check_result(8);
    A = ZERO; B = ZERO;
    check_result(0);
endtask
//////////////////////////////////////////////////////////
task Opcode_10;
    Opcode = 2'b10;
    A = MAXPOS; B = MAXPOS;
    check_result(MAXNEG);
    A = MAXPOS; B = MAXNEG;
    check_result(MAXNEG);
    A = MAXNEG; B = MAXPOS;
    check_result(MAXPOS);
    A = MAXNEG; B = MAXNEG;
    check_result(MAXPOS);
    A = MAXPOS; B = ZERO;
    check_result(MAXNEG);
    A = ZERO; B = MAXPOS;
    check_result(-1);
    A = MAXNEG; B = ZERO;
    check_result(MAXPOS);
    A = ZERO; B = MAXNEG;
    check_result(-1);
    A = ZERO; B = ZERO;
    check_result(-1);
endtask
//////////////////////////////////////////////////////////
task Opcode_11;
    Opcode = 2'b11;
    A = MAXPOS; B = MAXPOS;
    check_result(1);
    A = MAXPOS; B = MAXNEG;
    check_result(1);
    A = MAXNEG; B = MAXPOS;
    check_result(1);
    A = MAXNEG; B = MAXNEG;
    check_result(1);
    A = MAXPOS; B = ZERO;
    check_result(0);
    A = ZERO; B = MAXPOS;
    check_result(1);
    A = MAXNEG; B = ZERO;
    check_result(0);
    A = ZERO; B = MAXNEG;
    check_result(1);
    A = ZERO; B = ZERO;
    check_result(0);
endtask
//////////////////////////////////////////////////////////
task Opcode_xx;
    Opcode = 2'bXX;
    A = MAXPOS; B = MAXPOS;
    check_result(0);
    A = MAXPOS; B = MAXNEG;
    check_result(0);
    A = MAXNEG; B = MAXPOS;
    check_result(0);
    A = MAXNEG; B = MAXNEG;
    check_result(0);
    A = MAXPOS; B = ZERO;
    check_result(0);
    A = ZERO; B = MAXPOS;
    check_result(0);
    A = MAXNEG; B = ZERO;
    check_result(0);
    A = ZERO; B = MAXNEG;
    check_result(0);
    A = ZERO; B = ZERO;
    check_result(0);
endtask

endmodule