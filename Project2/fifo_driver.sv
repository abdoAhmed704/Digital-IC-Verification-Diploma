package fifo_driver_pkg;

import fifo_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_driver extends uvm_driver #(fifo_seq_item);
`uvm_component_utils(fifo_driver)

virtual fifo_interface fifo_vif;
fifo_seq_item seq_item;

function new(string name="fifo_driver", uvm_component parent=null);
    super.new(name, parent);
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        seq_item = fifo_seq_item::type_id::create("fifo_seq_item");

        seq_item_port.get_next_item(seq_item);

        fifo_vif.data_in    = seq_item.data_in;
        fifo_vif.rst_n      = seq_item.rst_n;
        fifo_vif.wr_en      = seq_item.wr_en;
        fifo_vif.rd_en      = seq_item.rd_en;
        @(negedge fifo_vif.clk);
        seq_item_port.item_done();
        `uvm_info("run_phase", seq_item.convert2string, UVM_MEDIUM)
    end
endtask



endclass

endpackage