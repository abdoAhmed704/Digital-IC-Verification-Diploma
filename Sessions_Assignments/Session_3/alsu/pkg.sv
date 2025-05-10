package ALSU_pkg;
typedef enum bit [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
typedef enum {MAXPOS=3, ZERO = 0, MAXNEG=-4} reg_e;

class ALSU_inputs;
  rand logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
  rand logic [2:0] A, B;
  rand opcode_e opcode;
  rand reg_e enum_ext_A, enum_ext_B;
  rand logic [3:0] A_rem_values, B_rem_values;
  bit [2:0] walking_ones[] = '{3'b001, 3'b010, 3'b100};
  rand bit [2:0] walking_ones_t, walking_ones_f;
  rand opcode_e opcode_array[6];

  int number_of_transaction = 0;

  opcode_e fixed_tr_array[$] = '{OR, XOR, ADD, MULT, SHIFT, ROTATE};

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
  
  covergroup cvr_gp ;

  A_cp: coverpoint A {
    bins A_data_0 = {0};
    bins A_data_max = {MAXPOS};
    bins A_data_min = {MAXNEG};
    bins A_data_default = default;
  }

  A_cp_red_op_A: coverpoint A iff(red_op_A){
    bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100};
  }

  B_cp: coverpoint B{
    bins B_data_0 = {0};
    bins B_data_max = {MAXPOS};
    bins B_data_min = {MAXNEG};
    bins B_data_default = default;
  }
  B_cp_red_op_B: coverpoint B iff(red_op_B && !red_op_A){
    bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100};
  }

  ALU_cp: coverpoint opcode {
    bins Bins_shift[] = {SHIFT, ROTATE};
    bins Bins_arith[] = {ADD, MULT};
    bins Bins_bitwise[] = {OR, XOR};
    bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
    illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
  }

  endgroup
  
    function new();
        cvr_gp = new();
    endfunction
endclass
endpackage
