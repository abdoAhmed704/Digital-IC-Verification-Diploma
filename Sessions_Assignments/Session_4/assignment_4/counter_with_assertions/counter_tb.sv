import counter_pkg::*;

module counter_tb(counter_if.TEST c_if);


counter_class obj = new();

always @(posedge c_if.clk) begin
    obj.covCode.sample();
end

initial begin
    assert_reset;
    repeat(4000)begin
        assert(obj.randomize());
        c_if.rst_n = obj.rst_n;
        c_if.load_n = obj.load_n;
        c_if.ce = obj.ce;
        c_if.up_down = obj.up_down;
        c_if.data_load = obj.data_load;
        @(negedge c_if.clk);
        obj.count_out = c_if.count_out;
    end
    $stop;
end


task assert_reset;
    c_if.rst_n = 0;
    @(negedge c_if.clk);
    c_if.count_out = 1;
    c_if.rst_n = 1;
endtask


endmodule


