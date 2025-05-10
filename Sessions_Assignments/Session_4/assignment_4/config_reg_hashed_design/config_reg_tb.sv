module config_reg_tb();

bit clk, reset, write;
bit [15:0] data_in;
bit [2:0] address;
logic [15:0] data_out;

typedef enum bit[2:0] {
    adc0_reg, adc1_reg, temp_sensor0_reg, temp_sensor1_reg,
    analog_test, digital_test, amp_gain, digital_config
} regs_t;

regs_t reg_add;
string keys[];

bit [15:0] reset_assoc[string];

int error_count = 0;
int correct_count = 0;



config_reg c_reg_inst(clk, reset, write, data_in, address, data_out);

// Clock generation
initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

// Initial stimulus
initial begin
    // Set expected reset values
    reset_assoc["adc0_reg"]         = 16'hFFFF;
    reset_assoc["adc1_reg"]         = 16'h0;
    reset_assoc["temp_sensor0_reg"] = 16'h0;
    reset_assoc["temp_sensor1_reg"] = 16'h0;
    reset_assoc["analog_test"]      = 16'hABCD;
    reset_assoc["digital_test"]     = 16'h0;
    reset_assoc["amp_gain"]         = 16'h0;
    reset_assoc["digital_config"]   = 16'h1;

    // Apply reset
    reset_regs();
    $display("start Checking All One .........");
    // Check each register for correct reset value
    for (reg_add = regs_t'(0); ; reg_add = regs_t'(reg_add.next())) begin
        address = reg_add;
        check_reset(reg_add.name());
        if (reg_add == reg_add.last()) break;
    end


    /////////////////////////////// Check ALL ones///////////////////////////////////////////////

    data_in = 16'hFFFF;
    write = 1;
    for (reg_add = regs_t'(0); ; reg_add = regs_t'(reg_add.next())) begin
        address = reg_add;
        check_result(reg_add.name());
        if (reg_add == reg_add.last()) break;
    end
    $display("End Checking All One   .........");
    
    $display("Start Checking One hot .........");
    

    /////////////////////////////// Check One Hot///////////////////////////////////////////////
    
    for (reg_add = regs_t'(0); ; reg_add = regs_t'(reg_add.next())) begin
        address = reg_add;
        data_in = 16'b0000;
        $display("check :::: %s", reg_add.name());
        for (int i = 0; i < 16; i++) begin
            data_in = 16'b1 << i;
            write = 1;
            @(negedge clk);
            write = 0;
            check_result(reg_add.name());
        end
        $display("END///check// %s", reg_add.name());
        reset_regs;
        if (reg_add == reg_add.last()) break;
    end
    $display("End Checking One hot .........");

    

    $display("Test completed. Errors: %0d, Correct: %0d", error_count, correct_count);
    $stop;
end

// Reset task
task reset_regs();
    reset = 1;
    write = 0;
    data_in = 0;
    @(negedge clk);
    reset = 0;
endtask

// Check reset value task
task check_reset(string reg_name);
    @(negedge clk);
    if (data_out !== reset_assoc[reg_name]) begin
        $display(" Error: Reset value for %s is wrong. Expected: %h, Got: %h",
                 reg_name, reset_assoc[reg_name], data_out);
        error_count++;
    end else begin
        $display(" Reset value for %s is correct: %h", reg_name, data_out);
        correct_count++;
    end
endtask

task check_result(string reg_name);
    @(negedge clk);
    if(data_in != data_out)begin
        $display(" Error:   %s, data_in = %h, data_out = %h", reg_name, data_in, data_out);
        error_count++;
    end
    else begin
        correct_count++;
        $display(" Correct: %s, data_in = %h, data_out = %h", reg_name, data_in, data_out);
    end
endtask
endmodule
