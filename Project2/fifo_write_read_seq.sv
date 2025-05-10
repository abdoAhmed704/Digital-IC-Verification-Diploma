package fifo_write_read_seq_pkg;
import fifo_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_write_read_seq extends uvm_sequence #(fifo_seq_item);
`uvm_object_utils(fifo_write_read_seq);
fifo_seq_item seq_item;

function new(string name = "fifo_write_read_seq");
    super.new(name);
endfunction

task body;
    seq_item = fifo_seq_item::type_id::create("seq_item");
    repeat(3000)begin 
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
    end
endtask
endclass
 
endpackage