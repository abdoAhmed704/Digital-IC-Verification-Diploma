package shift_reg_seq_item_pkg; 
import uvm_pkg::*;
`include "uvm_macros.svh"

class shift_reg_seq_item extends uvm_sequence_item;
`uvm_object_utils(shift_reg_seq_item);

rand bit reset;
rand bit serial_in, direction, mode;
rand bit [5:0] datain;
logic [5:0] dataout;


constraint reset_rst {
    reset dist{0:=2, 1:=98};
}


function new (string name = "shift_reg_seq_item");
    super.new(name);
endfunction

function string convert2string();
    return $sformatf("%s reset = %0b, serial_in = %0b, direction = %0b, mode = %0b, datain = %0b, dataout = %0b", super.convert2string(), reset, serial_in, direction, mode, datain, dataout);
endfunction

function string convert2string_stimulus();
    return $sformatf("reset = %0b, serial_in = %0b, direction = %0b, mode = %0b, datain = %0b, dataout = %0b", reset, serial_in, direction, mode, datain, dataout);
endfunction

endclass


class shift_reg_seq_item_dis_rst extends shift_reg_seq_item;
`uvm_object_utils(shift_reg_seq_item_dis_rst);
function new (string name = "shift_reg_seq_item_dis_rst");
    super.new(name);
endfunction

constraint reset_rst {
    reset dist{0:=100};
}

endclass

endpackage