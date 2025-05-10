package alsu_test_pkg;

import uvm_pkg::*;
import alsu_env_pkg::*;
import alsu_config_pkg::*;
import alsu_main_seq_pkg::*;
import alsu_reset_seq_pkg::*;

`include "uvm_macros.svh"

class alsu_test extends uvm_test;
  `uvm_component_utils(alsu_test)
  
  alsu_env env;

  alsu_config_obj alsu_config_obj_test;

  alsu_reset_seq reset_seq;
  alsu_main_seq main_seq;

  function new (string name = "alsu_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = alsu_env::type_id::create("env", this);
    alsu_config_obj_test = alsu_config_obj::type_id::create("alsu_config_obj");
    reset_seq = alsu_reset_seq::type_id::create("alsu_reset_seq");
    main_seq = alsu_main_seq::type_id::create("alsu_main_seq");

    if(!uvm_config_db #(virtual alsu_if)::get(this, "", "ALSU_KEY_VIF", alsu_config_obj_test.alsu_config_vif))
      `uvm_fatal("build phase", "Cannot get the virtual interface");
  
    uvm_config_db #(alsu_config_obj) :: set (this, "*", "ALUS_OBJ_SAVED", alsu_config_obj_test);
  endfunction

  task run_phase(uvm_phase phase);
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

endclass

endpackage
