package fifo_monitor_pkg;

import fifo_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_monitor extends uvm_monitor;
`uvm_component_utils(fifo_monitor)

virtual fifo_interface fifo_vif;

fifo_seq_item seq_item;
uvm_analysis_port #(fifo_seq_item) mon_ap;

function new(string name="fifo_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        seq_item = fifo_seq_item::type_id::create("fifo_seq_item");
        @(negedge fifo_vif.clk);

        seq_item.data_in = fifo_vif.data_in;
        seq_item.rst_n = fifo_vif.rst_n;
        seq_item.wr_en = fifo_vif.wr_en;
        seq_item.rd_en = fifo_vif.rd_en;
        seq_item.data_out = fifo_vif.data_out;
        seq_item.wr_ack = fifo_vif.wr_ack;
        seq_item.overflow = fifo_vif.overflow;
        seq_item.full = fifo_vif.full;
        seq_item.empty = fifo_vif.empty;
        seq_item.almostfull = fifo_vif.almostfull;
        seq_item.almostempty = fifo_vif.almostempty;
        seq_item.underflow = fifo_vif.underflow;

        mon_ap.write(seq_item);
        `uvm_info("run_phase", seq_item.convert2string, UVM_MEDIUM)

    end
endtask


endclass



endpackage