package shift_reg_monitor_pkg;

import shift_config_pkg::*; 

import shift_reg_seq_item_pkg::*; 
import uvm_pkg::*;
`include "uvm_macros.svh"


class shift_reg_monitor extends uvm_monitor;
`uvm_component_utils(shift_reg_monitor)

virtual shift_reg_if shift_vif;
shift_reg_seq_item shift_seq_item;
uvm_analysis_port #(shift_reg_seq_item) mon_ap;

function new(string name="shift_reg_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        shift_seq_item = shift_reg_seq_item::type_id::create("shift_reg_seq_item");
        
        @(negedge shift_vif.clk);

        shift_seq_item.reset = shift_vif.reset; 
        shift_seq_item.serial_in = shift_vif.serial_in;
        shift_seq_item.direction = shift_vif.direction;
        shift_seq_item.mode = shift_vif.mode;
        shift_seq_item.datain = shift_vif.datain;
        shift_seq_item.dataout =  shift_vif.dataout;
        mon_ap.write(shift_seq_item);
        `uvm_info("run_phase", shift_seq_item.convert2string, UVM_MEDIUM)

    end
endtask



endclass

endpackage