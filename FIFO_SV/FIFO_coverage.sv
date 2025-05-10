package FIFO_coverage_pkg;
import shared_pkg::*;
import FIFO_transaction_pkg::*;


class FIFO_coverage;
    FIFO_transaction F_cvg_txn = new();



    covergroup w_r_outs_cover_group;

        wr_en_cp    : coverpoint  F_cvg_txn.wr_en;
        rd_en_cp    : coverpoint  F_cvg_txn.rd_en;
        ack_cp      : coverpoint  F_cvg_txn.wr_ack;
        overflow_cp : coverpoint  F_cvg_txn.overflow;
        full_cp     : coverpoint  F_cvg_txn.full;
        underf_cp   : coverpoint  F_cvg_txn.underflow;

        Cross_rd_wr_Ack      : cross wr_en_cp, rd_en_cp, ack_cp{
                                    ignore_bins wr_en_with_wr_ack = ! binsof(wr_en_cp) intersect {1} && binsof(ack_cp) intersect {1};
                                    ignore_bins rd_en_active_with_wr_ack = ! binsof(wr_en_cp) intersect {1} && binsof(rd_en_cp) intersect {1} && binsof(ack_cp) intersect {1}; 
                                }

        Cross_rd_wr_overflow : cross wr_en_cp, rd_en_cp, overflow_cp{
                                    ignore_bins wr_en_with_overflow = ! binsof(wr_en_cp) intersect {1} && binsof(overflow_cp) intersect {1};
                                }
        Cross_rd_wr_full     : cross wr_en_cp, rd_en_cp, full_cp{
                                    ignore_bins write_full = ! binsof(wr_en_cp) intersect {1} && binsof(full_cp) intersect {1};
                                    ignore_bins all_ones = binsof(wr_en_cp) intersect {1}  && binsof(full_cp) intersect {1} && binsof(rd_en_cp) intersect {1};
                                }
        Cross_rd_wr_empty    : cross wr_en_cp, rd_en_cp, F_cvg_txn.empty;
        Cross_rd_wr_almostf  : cross wr_en_cp, rd_en_cp, F_cvg_txn.almostfull;
        Cross_rd_wr_almostem : cross wr_en_cp, rd_en_cp, F_cvg_txn.almostempty;
        Cross_rd_wr_unoverf  : cross wr_en_cp, rd_en_cp, underf_cp{
            ignore_bins one_0_one = binsof (wr_en_cp) intersect {1}  && binsof(rd_en_cp) intersect {0}  && binsof(underf_cp)intersect {1} ;
            ignore_bins zerp_zero_one = binsof (wr_en_cp) intersect {0}  && binsof(rd_en_cp) intersect {0}  && binsof(underf_cp) intersect {1} ;

        }
    endgroup

    function new();
        w_r_outs_cover_group = new();
    endfunction
    
    function void sample_data(FIFO_transaction F_txn);
        F_cvg_txn = F_txn;
        w_r_outs_cover_group.sample();
    endfunction

endclass

endpackage