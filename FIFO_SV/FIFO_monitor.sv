module FIFO_monitor(FIFO_interface.MON fifo_if);

import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import shared_pkg::*;

FIFO_coverage cover_obj;
FIFO_transaction trans_obj;
FIFO_scoreboard score_obj;

initial begin
    cover_obj = new();
    trans_obj = new();
    score_obj = new();

    forever begin
        @(test_trigger);
        @(negedge fifo_if.clk);

        `ifdef DEBUG
        $display("****************  After trigger *******************");
        $display("tb: rst_n=%0d, data_in=%0d, wr_en=%0d, rd_en=%0d", fifo_if.rst_n, fifo_if.data_in, fifo_if.wr_en, fifo_if.rd_en);
        $display("dut_out = %0d", fifo_if.data_out);
        $display("***************************************************");
        `endif 

        trans_obj.data_in       = fifo_if.data_in;
        trans_obj.rst_n         = fifo_if.rst_n;
        trans_obj.wr_en         = fifo_if.wr_en;
        trans_obj.rd_en         = fifo_if.rd_en;
        trans_obj.data_out      = fifo_if.data_out;
        trans_obj.wr_ack        = fifo_if.wr_ack;
        trans_obj.overflow      = fifo_if.overflow;
        trans_obj.full          = fifo_if.full;
        trans_obj.empty         = fifo_if.empty;
        trans_obj.almostfull    = fifo_if.almostfull;
        trans_obj.almostempty   = fifo_if.almostempty;
        trans_obj.underflow     = fifo_if.underflow;

        fork
            begin

                cover_obj.sample_data(trans_obj);
            end
            begin
                score_obj.check_data(trans_obj);
            end
        join
        if (test_finish) begin
            $display("Simulation finished");
            $display("Correct count = %0d", correct_count);
            $display("Error count   = %0d", error_count);
            $stop;
        end
    end
end

endmodule
