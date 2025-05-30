interface FIFO_interface(input clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    modport DUT  (input data_in, rst_n, wr_en, rd_en, clk, output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    modport TEST (output data_in, rst_n, wr_en, rd_en, clk, input data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    modport MON (input data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow, clk);
endinterface
