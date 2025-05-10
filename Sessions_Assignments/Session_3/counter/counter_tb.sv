import counter_pkg::*;

module counter_tb();
bit clk;
bit rst_n;
bit load_n;
bit up_down;
bit ce;
bit [WIDTH-1:0] data_load;

bit load_n_reg;
bit up_down_reg;
bit ce_reg;
bit [WIDTH-1:0] data_load_reg;

logic  [WIDTH-1:0] count_out;
bit [WIDTH-1:0] count_out_Expected;

logic max_count;
bit max_count_ex;

logic zero;
bit zero_ex;

counter #(.WIDTH(WIDTH)) co (.*);

counter_class obj = new();

int ErrorCounter = 0, CorrectCounter = 0;

initial begin
    clk = 0;
    forever begin
        #2 clk = ~clk;
    end 
end

always @(posedge clk) begin
    obj.covCode.sample();
end

always_comb begin
    if(!rst_n)
        a_reset: assert final(count_out == 0);
end

initial begin
    assert_reset;
    repeat(4000)begin
        assert(obj.randomize());
        rst_n = obj.rst_n;
        load_n = obj.load_n;
        ce = obj.ce;
        up_down = obj.up_down;
        data_load = obj.data_load;
        
        if (!obj.rst_n)begin
            check_reset;
            reset_internals;
        end
        else begin
        // GOLDEN MODEL 
        golden_model;
        // check result
        check_result;
        end 
        obj.count_out = count_out;
    end

    $display("We found [%0d] errors and [%0d] Correct", ErrorCounter, CorrectCounter);
    $stop;
end


task assert_reset;
    rst_n = 0;
    check_reset();
    rst_n = 1;
endtask

task golden_model;
    update_internals;
    if(!load_n_reg)begin
        count_out_Expected = data_load_reg;
    end
    else if (ce_reg)
        if (up_down_reg)
            count_out_Expected++;
        else 
            count_out_Expected--;

    max_count_ex = (count_out_Expected == {WIDTH{1'b1}})? 1:0;
    zero_ex = (count_out_Expected == 0)? 1:0;
endtask

task update_internals;
    load_n_reg = load_n;
    up_down_reg = up_down;
    ce_reg = ce;
    data_load_reg = data_load;
endtask

task check_result;
    @(negedge clk);
    if (count_out != count_out_Expected || max_count != max_count_ex || zero_ex != zero_ex)begin
        $display("Error///");
        ErrorCounter++;
    end
    else
        CorrectCounter++;
    $display("%0t, rst_n = %0d,  load_n = %0d,  up_down = %0d,  ce = %0d,  data_load = %0d, load_n = %0d", $time, rst_n, load_n, up_down, ce, data_load, load_n);
    $display("%0t, count_out = %0d,  count_out_ex = %0d,  max_count = %0d,   max_count_ex = %0d,  zero = %0d, zero_ex = %0d", $time, count_out, count_out_Expected, max_count, max_count_ex,  zero, zero_ex);

endtask

task check_reset;
    @(negedge clk);
    if (count_out  || !zero || max_count)begin
        $display("Error: %0t -- Reset is not working", $time);
        ErrorCounter++;
    end
    else
        CorrectCounter++;
    $display("%0t, rst_n = %0d,  load_n = %0d,  up_down = %0d,  ce = %0d,  data_load = %0d, load_n = %0d", $time, rst_n, load_n, up_down, ce, data_load, load_n);
    $display("%0t, count_out = %0d,  count_out_ex = %0d,  max_count = %0d,   max_count_ex = %0d,  zero = %0d, zero_ex = %0d", $time, count_out, count_out_Expected, max_count, max_count_ex,  zero, zero_ex);

endtask

task reset_internals;
    load_n_reg = 0;
    up_down_reg = 0;
    ce_reg = 0;
    data_load_reg = 0;
    count_out_Expected = 0;
    zero_ex = 1;
    max_count_ex = 0;
endtask

endmodule


