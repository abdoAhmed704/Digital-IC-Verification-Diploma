package FIFO_transaction_pkg;

import shared_pkg::*;

class FIFO_transaction;
    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    int RD_EN_ON_DIST, WR_EN_ON_DIST;

    function new (int RD_EN_ON_DIST_params=30, WR_EN_ON_DIST_params=70);
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
endclass

endpackage

