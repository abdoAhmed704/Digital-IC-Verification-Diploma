package alsu_main_seq_pkg;
import alsu_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_main_seq extends uvm_sequence #(alsu_seq_item); 
`uvm_object_utils(alsu_main_seq);
alsu_seq_item seq_item;

function new(string name = "alsu_main_seq");
    super.new(name);
endfunction

task body;
    seq_item = alsu_seq_item::type_id::create("seq_item");
    repeat(25000)begin 
    start_item(seq_item);
    assert(seq_item.randomize());
    finish_item(seq_item);
    end
    
endtask

endclass
endpackage