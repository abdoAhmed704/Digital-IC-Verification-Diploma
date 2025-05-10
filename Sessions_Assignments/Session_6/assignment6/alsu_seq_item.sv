package alsu_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum bit [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
typedef enum {MAXPOS=3, ZERO = 0, MAXNEG=-4} reg_e;

 
class alsu_seq_item extends uvm_sequence_item;
`uvm_object_utils(alsu_seq_item)

rand logic rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
rand logic [2:0] A, B;
rand opcode_e opcode;

logic [15:0] leds;
logic [5:0] out;


rand reg_e enum_ext_A, enum_ext_B;
rand logic [3:0] A_rem_values, B_rem_values;

bit [2:0] walking_ones[] = '{3'b001, 3'b010, 3'b100};
rand bit [2:0] walking_ones_t, walking_ones_f;
rand opcode_e opcode_array[6];

int number_of_transaction = 0;

opcode_e fixed_tr_array[$] = '{OR, XOR, ADD, MULT, SHIFT, ROTATE};

////////////////////////////    constraint    ///////////////////////////////////////////

// ALSU_1
constraint rst_con {
rst dist {1:= 2, 0:= 98};
}


constraint A_B_con {
A_rem_values != MAXPOS || 0 || MAXNEG;
B_rem_values != MAXPOS || 0 || MAXNEG;
walking_ones_t inside {walking_ones};
!(walking_ones_f inside {walking_ones});

if (opcode == OR || opcode == XOR) {
    // ALSU_5, ALSU_7
    if (red_op_A == 1) {
    B == 0;
    A dist {walking_ones_t:= 80, walking_ones_f:= 20};
    } else if (red_op_B == 1) {
    A == 0;
    B dist {walking_ones_t:= 80, walking_ones_f:= 20};
    }
} else {
    // ALSU_4, ALSU_6
    red_op_A dist {1:= 0, 0:= 80};
    red_op_B dist {1:= 20, 0:= 80};
    // ALSU_2, ALSU_3
    if (opcode == ADD || opcode == MULT) {
    A dist {enum_ext_A:= 80, A_rem_values:= 20};
    B dist {enum_ext_B:= 80, B_rem_values:= 20};
    }
}
}


// ALSU_10
constraint opcode_con {

if (fixed_tr_array.size()){
    bypass_A == 0;
    bypass_B == 0;
    rst == 0;
    opcode == fixed_tr_array.pop_front();
}
else
    opcode dist {[OR:ROTATE]:= 80, [INVALID_6:INVALID_7]:= 20};

}


// ALSU_11
constraint bypass_con {
bypass_A dist {1:= 2, 0:= 98};
bypass_B dist {1:= 2, 0:= 98};
}

// last constraint 
constraint array_con{
foreach (opcode_array[i]) {
    foreach(opcode_array[j]){
    if(i != j){
        opcode_array[i] != opcode_array[j];
        opcode_array[i] inside {[OR: ROTATE]};
    }
    }
}
}
  
////////////////////////////////// end constaint   /////////////////////////////////////////////////

function new (string name = "alsu_seq_item");
    super.new(name);
endfunction

function string convert2string();
    return $sformatf("%s rst = %0d, cin = %0d, red_op_A = %0d, red_op_B = %0d, bypass_A = %0d, bypass_B = %0d, direction = %0d, serial_in = %0d, A = %0d, B = %0d, opcode = %0d, out = %0d, leds=%0h", super.convert2string(), rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, A, B, opcode, out, leds);
endfunction

function string convert2string_stimulus();
    return $sformatf("rst = %0d, cin = %0d, red_op_A = %0d, red_op_B = %0d, bypass_A = %0d, bypass_B = %0d, direction = %0d, serial_in = %0d, A = %0d, B = %0d, opcode = %0d, out = %0d, leds=%0h", rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, A, B, opcode, out, leds);
endfunction



endclass

endpackage