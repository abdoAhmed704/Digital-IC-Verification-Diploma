package alsu_coverage_pkg;
import alsu_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum bit [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
typedef enum {MAXPOS=3, ZERO = 0, MAXNEG=-4} reg_e;


class alsu_coverage extends uvm_component;
`uvm_component_utils(alsu_coverage);


uvm_analysis_export #(alsu_seq_item) cov_export;
uvm_tlm_analysis_fifo #(alsu_seq_item) cov_fifo;
alsu_seq_item seq_item_cov;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  covergroup cvr_gp;
//
  A_cp: coverpoint seq_item_cov.A {
    bins A_data_0 = {0};
    bins A_data_max = {MAXPOS};
    bins A_data_min = {MAXNEG};
    bins A_data_default = default;
  }

  A_cp_red_op_A: coverpoint seq_item_cov.A iff(seq_item_cov.red_op_A){
    bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100};
  }

  B_cp: coverpoint seq_item_cov.B{
    bins B_data_0 = {0};
    bins B_data_max = {MAXPOS};
    bins B_data_min = {MAXNEG};
    bins B_data_default = default;
  }
  B_cp_red_op_B: coverpoint seq_item_cov.B iff(seq_item_cov.red_op_B && !seq_item_cov.red_op_A){
    bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100};
  }

  ALU_cp: coverpoint seq_item_cov.opcode {
    bins Bins_shift[] = {SHIFT, ROTATE};
    bins Bins_arith[] = {ADD, MULT};
    bins Bins_bitwise[] = {OR, XOR};
    bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
    illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
  }

  SHIFT_ROTATE: coverpoint seq_item_cov.opcode{
    bins new_Bins_shift[] = {SHIFT, ROTATE};
  }
  CROSS_A_B_ADD_MULT: cross A_cp, B_cp, ALU_cp{
      ignore_bins ignort_Bins_bitwise = binsof(ALU_cp.Bins_bitwise);
      ignore_bins ignort_Bins_shift = binsof(ALU_cp.Bins_shift);
      ignore_bins ignort_Bins_trans = binsof(ALU_cp.Bins_trans);
  }

  CROSS_dirc_shift_rotate: cross seq_item_cov.direction, ALU_cp{
    bins ig_bins_shift = binsof(ALU_cp.Bins_shift);
    option.cross_auto_bin_max = 0;
  }
  Cover_shift: coverpoint seq_item_cov.opcode{
    bins bin_shift = {SHIFT};
  }

  CROSS_WALKING_ONE_A: cross A_cp_red_op_A, B_cp, SHIFT_ROTATE iff(seq_item_cov.red_op_A){
    bins A_TOOK = binsof(A_cp_red_op_A);
    ignore_bins ign_B_max = binsof(B_cp.B_data_max);
    ignore_bins ign_B_min = binsof(B_cp.B_data_min);
  }
    CROSS_WALKING_ONE_B: cross B_cp_red_op_B, A_cp, SHIFT_ROTATE iff(seq_item_cov.red_op_B){
    ignore_bins ign_A_max = binsof(A_cp.A_data_max);
    ignore_bins ign_A_min = binsof(A_cp.A_data_min);
  }

  OPCODE_FROM_ADD_TO_END: coverpoint seq_item_cov.opcode{
    option.weight = 0;
    bins ADD_TO_END[] = {[ADD: $]};
  }


  endgroup
//
 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function new(string name="shift_reg_coverage", uvm_component parent);
    super.new(name, parent);
    cvr_gp = new(); 
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
        cvr_gp.sample();
    end
endtask


endclass


endpackage