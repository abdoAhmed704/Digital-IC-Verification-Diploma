
interface counter_if(input clk);
    parameter WIDTH = 4;
    
    logic rst_n;
    logic load_n;
    logic up_down;
    logic ce;
    logic [WIDTH-1:0] data_load;
    logic [WIDTH-1:0] count_out;
    logic max_count;
    logic zero;

    modport DUT (input clk, rst_n, load_n, up_down, ce, data_load, output count_out, max_count, zero);
    modport TEST (input count_out, max_count, zero , output clk, rst_n, load_n, up_down, ce, data_load);
    modport MON (input count_out, max_count, zero, clk, rst_n, load_n, up_down, ce, data_load);
endinterface
