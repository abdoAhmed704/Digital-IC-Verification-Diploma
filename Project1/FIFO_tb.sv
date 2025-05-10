import shared_pkg::*;
import FIFO_transaction_pkg::*;

FIFO_transaction trans_obj = new();

module FIFO_tb (FIFO_interface.TEST fifo_if);

int loop_count = 0;
initial begin
    #0;
    
    direct_test;
    
    repeat(10000)begin
        assert(trans_obj.randomize());
        fifo_if.data_in = trans_obj.data_in;
        fifo_if.wr_en = trans_obj.wr_en;
        fifo_if.rd_en = trans_obj.rd_en;
        fifo_if.rst_n = trans_obj.rst_n;
        
        `ifdef DEBUG
        $display("****************  in  tb *******************");
        $display("tb: rst_n=%0d, data_in=%0d, wr_en=%0d, rd_en=%0d", trans_obj.rst_n, trans_obj.data_in, trans_obj.wr_en, trans_obj.rd_en);
        $display("********************************************");
        `endif 
        
        -> test_trigger;
        @(negedge fifo_if.clk);


    end
    -> test_trigger;
    test_finish = 1;
end

task direct_test;
    #0;
    fifo_if.rst_n = 0;
    -> test_trigger;
    @(negedge fifo_if.clk); 
    fifo_if.rst_n = 1;
    $display("Writting...............................................");
    fifo_if.data_in = 121;
    fifo_if.wr_en = 1;
    fifo_if.rd_en = 0;
    -> test_trigger;
    @(negedge fifo_if.clk); 
    
    fifo_if.data_in = 122;
    fifo_if.wr_en = 1;
    fifo_if.rd_en = 0;
    -> test_trigger;
    @(negedge fifo_if.clk);

    fifo_if.data_in = 123;
    fifo_if.wr_en = 1;
    fifo_if.rd_en = 0;
    -> test_trigger;
    @(negedge fifo_if.clk);
    ///////////////////
    $display("Reading ...............................................");
    fifo_if.data_in = 333;
    fifo_if.wr_en = 0;
    fifo_if.rd_en = 1;
    -> test_trigger;
    @(negedge fifo_if.clk);

    fifo_if.data_in = 444;
    fifo_if.wr_en = 0;
    fifo_if.rd_en = 1;
    -> test_trigger;
    @(negedge fifo_if.clk);

    fifo_if.data_in = 555;
    fifo_if.wr_en = 0;
    fifo_if.rd_en = 1;
    -> test_trigger;
    @(negedge fifo_if.clk);

    fifo_if.data_in = 333;
    fifo_if.wr_en = 0;
    fifo_if.rd_en = 1;
    -> test_trigger;
    @(negedge fifo_if.clk);

endtask

endmodule