////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_test_pkg;

import shift_reg_env_pkg::*;
import shift_config_pkg::*;
import shift_reg_reset_seq_pkg::*;
import shift_reg_main_seq_pkg::*;
import shift_reg_seq_item_pkg::*;

import uvm_pkg::*;  
`include "uvm_macros.svh"


class shift_reg_test extends uvm_test;
  `uvm_component_utils(shift_reg_test)
  // Example 1
  // Do the essentials (factory register & Constructor)
  function new(string name = "shift_reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the enviornment in the build phase
  shift_reg_env env;
  shift_config shift_config_obj;
  shift_reg_reset_seq reset_seq;
  shift_reg_main_seq main_seq;

  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    env = shift_reg_env::type_id::create("env", this);
    shift_config_obj = shift_config::type_id::create("shift_config_obj", this);
    reset_seq = shift_reg_reset_seq::type_id::create("shift_reg_reset_seq");
    main_seq = shift_reg_main_seq::type_id::create("shift_reg_main_seq");

    set_type_override_by_type(shift_reg_seq_item::get_type(), shift_reg_seq_item_dis_rst::get_type());

    if(!(uvm_config_db #(virtual shift_reg_if) :: get (this, "", "SHIFT_KEY_VIF", shift_config_obj.shift_vif)))
      `uvm_fatal("build phase", "Cannot get the virtual interface");
    uvm_config_db #(shift_config) :: set (this, "*", "SHIFT_KEY_COBJ", shift_config_obj);
  endfunction

  

  // Run in the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
    task run_phase (uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      // reset seq
      `uvm_info("run_phase", "RESET Asserted", UVM_MEDIUM)
      reset_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "RESET deAsserted", UVM_MEDIUM)

      // main seq
      `uvm_info("run_phase", "Main Asserted", UVM_MEDIUM)
      main_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "Main deAsserted", UVM_MEDIUM)


      
      phase.drop_objection(this);
    endtask

  // Example 2
  // Build the config object in the build phase
  // get the virtual interface and assign it to the virtual interface of the config object
  // set the config obj in the config db
endclass: shift_reg_test
endpackage