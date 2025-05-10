interface fifo_internal_interface(input clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
    logic [max_fifo_addr:0] count;
endinterface