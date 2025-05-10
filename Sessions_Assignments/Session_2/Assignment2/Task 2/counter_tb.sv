import counter_pkg::*;

module counter_tb();
reg clk;
reg rst_n;
reg load_n;
reg up_down;
reg ce;
reg [WIDTH-1:0] data_load;
wire  [WIDTH-1:0] count_out;
reg [WIDTH-1:0] count_out_Expected;
wire max_count;
reg max_count_ex;
wire zero;
reg zero_ex;

counter #(.WIDTH(WIDTH)) co (.*);

counter_class obj = new();

int ErrorCounter = 0, CorrectCounter = 0;

initial begin
    clk = 0;
    forever begin
        #2 clk = ~clk;
    end 
end

initial begin
    assert_reset;
    repeat(200)begin
        assert(obj.randomize());
        rst_n = obj.rst_n;
        load_n = obj.load_n;
        ce = obj.ce;
        up_down = obj.up_down;
        data_load = obj.data_load;
    
        // GOLDEN MODEL 
        golden_model;

        // check result
        check_result;

        @(negedge clk);
    end

    $display("We found [%0d] errors and [%0d] Correct", ErrorCounter, CorrectCounter);
    $stop;
end


task assert_reset;
    rst_n = 0;
    @(negedge clk);
    if (count_out != 0 && max_count !=0 && zero == 1)begin
        $display("Error in reset assert");
        ErrorCounter++;
    end
    else begin
        CorrectCounter++;
    end
    rst_n = 1;
endtask

task golden_model;
    if (!rst_n)
        count_out_Expected <= 0;
    else if (!load_n)
        count_out_Expected <= data_load;
    else if (ce)
        if (up_down)
            count_out_Expected <= count_out_Expected + 1;
        else 
            count_out_Expected <= count_out_Expected - 1;
    max_count_ex = (count_out_Expected == {WIDTH{1'b1}})? 1:0;
    zero_ex = (count_out_Expected == 0)? 1:0;
endtask

task check_result;
    if (count_out_Expected != count_out)begin
        $display("The output Value doen't Match with the Golden model");
        ErrorCounter++;
    end
    else begin
        CorrectCounter++;
    end
    if (max_count_ex != max_count)begin
        $display("The max_count Value doen't Match with the Golden model");
        ErrorCounter++;
    end
    else begin
        CorrectCounter++;
    end
    if (zero_ex != zero)begin
        $display("The Zero Value doen't Match with the Golden model");
        ErrorCounter++;
    end
    else begin
        CorrectCounter++;
    end

endtask

endmodule