package fifo_coverage_pkg;

import fifo_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_coverage extends uvm_component;
`uvm_component_utils(fifo_coverage);

uvm_analysis_export #(fifo_seq_item) cov_export;
uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
fifo_seq_item seq_item_cov;

////////////// Coverage group ////////////////
covergroup w_r_outs_cover_group;

    wr_en_cp    : coverpoint  seq_item_cov.wr_en;
    rd_en_cp    : coverpoint  seq_item_cov.rd_en;
    ack_cp      : coverpoint  seq_item_cov.wr_ack;
    overflow_cp : coverpoint  seq_item_cov.overflow;
    full_cp     : coverpoint  seq_item_cov.full;
    underf_cp   : coverpoint  seq_item_cov.underflow;

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
    Cross_rd_wr_empty    : cross wr_en_cp, rd_en_cp, seq_item_cov.empty;
    Cross_rd_wr_almostf  : cross wr_en_cp, rd_en_cp, seq_item_cov.almostfull;
    Cross_rd_wr_almostem : cross wr_en_cp, rd_en_cp, seq_item_cov.almostempty;
    Cross_rd_wr_unoverf  : cross wr_en_cp, rd_en_cp, underf_cp{
        ignore_bins one_0_one = binsof (wr_en_cp) intersect {1}  && binsof(rd_en_cp) intersect {0}  && binsof(underf_cp)intersect {1} ;
        ignore_bins zerp_zero_one = binsof (wr_en_cp) intersect {0}  && binsof(rd_en_cp) intersect {0}  && binsof(underf_cp) intersect {1} ;

    }
endgroup
////////////


function new(string name="fifo_coverage", uvm_component parent);
    super.new(name, parent);
    w_r_outs_cover_group = new(); 
endfunction
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo = new("cov_fifo", this);
endfunction
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction
task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(seq_item_cov);
        w_r_outs_cover_group.sample();
    end
endtask


endclass


endpackage