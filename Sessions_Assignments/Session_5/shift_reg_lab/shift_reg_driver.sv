package shift_driver_pkg;

import shift_config_pkg::*; 

import shift_reg_seq_item_pkg::*; 
import uvm_pkg::*;
`include "uvm_macros.svh"


`include "uvm_macros.svh"
class shift_driver extends uvm_driver #(shift_reg_seq_item);

`uvm_component_utils(shift_driver)

// local virtual interface to easy access:
virtual shift_reg_if shift_vif;
shift_reg_seq_item shift_seq_item;


function new(string name = "shift_driver", uvm_component parent = null);
    super.new(name, parent); 
endfunction

// function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
    
// endfunction

// function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     shift_vif = config_obj.shift_vif;
// endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        shift_seq_item = shift_reg_seq_item::type_id::create("shift_seq_item");
        seq_item_port.get_next_item(shift_seq_item);


        shift_vif.reset = shift_seq_item.reset;
        shift_vif.serial_in = shift_seq_item.serial_in;
        shift_vif.direction = shift_seq_item.direction;
        shift_vif.mode = shift_seq_item.mode;
        shift_vif.datain = shift_seq_item.datain;

        @(negedge shift_vif.clk);
        `uvm_info("run_phase", shift_seq_item.convert2string, UVM_MEDIUM)
        seq_item_port.item_done();
    end
    $stop;
endtask

endclass
endpackage