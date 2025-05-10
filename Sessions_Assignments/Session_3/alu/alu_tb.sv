import package_name::*;

module alu_tb();

bit clk, rst;
byte operand1, operand2, out, out_ex;
opcode_e opcode;

alu_seq DUT (operand1, operand2, clk, rst, opcode, out);

Transaction tr = new();

int correctCount, errorCount;

initial begin
   clk = 0;
   tr.clk = 0;

    forever begin
        #2 clk = ~clk;
        tr.clk = clk;
    end
end

initial begin
    rst = 0;
    @(negedge clk);
    
    reset;
    repeat(100)begin
        assert(tr.randomize);
        tr.post_randomize();
        operand1 = tr.operand1;
        operand2 = tr.operand2;
        opcode = tr.opcode;

        @(posedge clk); // دخول القيم
        goldenModel;

        check;
    end
    $display("Correct [%0d], Error [%0d]", correctCount, errorCount);
    $stop;
end

task reset ;
    rst = 1;
    @(negedge clk);
    if(out != 0)begin
        $display("Error in assert rst");
        errorCount++;
    end
    else
        correctCount++;
    rst = 0;
endtask

task goldenModel();
    case (opcode)
        ADD: out_ex = operand1 + operand2;
        SUB: out_ex = operand1 - operand2;
        MULT:out_ex = operand1 * operand2; 
        DIV: out_ex = operand1 / operand2;
        default: out_ex = 0;
    endcase
endtask

task check;
    @(negedge clk);
    if (out_ex != out)begin
        $display("Error happend....");
        errorCount++;
    end
    else
        correctCount++;
endtask

initial begin
$monitor("operand1 = %0d, operand2 = %0d, opcode = %s, out = %0d, out_ex = %0d", operand1, operand2, opcode.name(), out, out_ex);

end


endmodule