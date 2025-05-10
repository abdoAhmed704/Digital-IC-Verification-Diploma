////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////

package shift_reg_env_pkg;
import shift_driver_pkg::*;
import shift_reg_agent_pkg::*;
import shift_reg_sequencer_pkg::*;
import shift_reg_scoreboard_pkg::*;
import shift_reg_coverage_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"


class shift_reg_env extends uvm_env;
  `uvm_component_utils(shift_reg_env)
/*
  shift_driver driver;
  shift_reg_sequencer sqr;
*/
  shift_reg_agent agt;
  shift_reg_scoreboard sb;
  shift_reg_coverage cov;


  // Example 1
  // Do the essentials (factory register & Constructor)
  function new(string name = "shift_reg_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Example 2
  // Build the driver in the build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = shift_reg_agent::type_id::create("agt", this);
    sb = shift_reg_scoreboard::type_id::create("shift_reg_scoreboard", this);
    cov = shift_reg_coverage::type_id::create("shift_reg_coverage", this);

    /*
    driver = shift_driver::type_id::create("shift_driver", this);
    sqr = shift_reg_sequencer::type_id::create("shift_reg_sequencer", this);
    */

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // driver.seq_item_port.connect(sqr.seq_item_export);
    agt.agt_ap.connect(sb.sb_export);
    agt.agt_ap.connect(cov.cov_export);
  endfunction


endclass
endpackage