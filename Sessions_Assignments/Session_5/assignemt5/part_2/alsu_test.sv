package alsu_test_pkg;

import uvm_pkg::*;
import alsu_env_pkg::*;
`include "uvm_macros.svh"

class alsu_test extends uvm_test;
  `uvm_component_utils(alsu_test)
  
  alsu_env env;
  virtual alsu_if alsu_test_vif;

  function new (string name = "alsu_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = alsu_env::type_id::create("env", this);
    if(!uvm_config_db #(virtual alsu_if)::get(this, "", "ALSU_KEY_VIF", alsu_test_vif))
      `uvm_fatal("build phase", "Cannot get the virtual interface");
  
    uvm_config_db #(virtual alsu_if) :: set (this, "*", "SHIFT_KEY_COBJ", alsu_test_vif);

  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    #100; `uvm_info("run_phase", "Inside the ALSU test", UVM_MEDIUM)
    phase.drop_objection(this);
  endtask

endclass

endpackage
