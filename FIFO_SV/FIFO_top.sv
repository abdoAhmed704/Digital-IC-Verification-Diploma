module FIFO_top;
bit clk;
initial begin
    forever
        #10 clk=~clk;
end

FIFO_interface if_inst (clk);
FIFO dut (if_inst);
FIFO_tb fifo_tb_inst (if_inst);
FIFO_monitor fifo_monitor (if_inst);

endmodule