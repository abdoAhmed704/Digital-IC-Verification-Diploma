module top();

bit clk;

initial begin
    forever
        #1 clk = ~clk;
end

counter_if c_if (clk);
counter dut (c_if);
counter_tb c_tb(c_if);
bind counter counter_sva sva_inst (c_if);


endmodule