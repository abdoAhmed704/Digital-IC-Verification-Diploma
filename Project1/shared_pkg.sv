package shared_pkg;

int error_count = 0;

int correct_count = 0;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

bit test_finish = 0;

event test_trigger;

endpackage