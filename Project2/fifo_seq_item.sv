package fifo_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
parameter FIFO_WIDTH = 16;
 parameter FIFO_DEPTH = 8;
 
class fifo_seq_item extends uvm_sequence_item;
`uvm_object_utils(fifo_seq_item);

rand logic [FIFO_WIDTH-1:0] data_in;
rand logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

int RD_EN_ON_DIST, WR_EN_ON_DIST;


function new (string name = "fifo_seq_item", int RD_EN_ON_DIST_params=30, int WR_EN_ON_DIST_params=70);
    super.new(name);

    RD_EN_ON_DIST = RD_EN_ON_DIST_params;
    WR_EN_ON_DIST = WR_EN_ON_DIST_params;
endfunction

constraint Reset_con {
    rst_n dist {1:/90, 0:/10};
}

constraint Wr_en_con{
    wr_en dist {1:/WR_EN_ON_DIST, 0:/(100-WR_EN_ON_DIST)};
}


constraint Rd_en_con{
    wr_en dist {1:/RD_EN_ON_DIST, 0:/(100-RD_EN_ON_DIST)};
}


function string convert2string();
    return $sformatf("rst_n = %0d, wr_en = %0d, rd_en = %0d, data_in = %0d, data_out = %0d, wr_ack = %0d, overflow = %0d, full = %0d, empty = %0d, almostfull = %0d, almostempty = %0d, underflow = %0d", 
                     rst_n, wr_en, rd_en, data_in, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
endfunction

endclass



endpackage