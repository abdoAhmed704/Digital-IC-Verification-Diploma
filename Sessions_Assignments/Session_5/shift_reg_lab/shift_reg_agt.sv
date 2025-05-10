package shift_reg_agent_pkg;
import shift_driver_pkg::*;
import shift_config_pkg::*;
import shift_reg_sequencer_pkg::*;
import shift_reg_monitor_pkg::*;
import shift_reg_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class shift_reg_agent extends uvm_agent;
`uvm_component_utils(shift_reg_agent)

shift_driver driver;
shift_reg_sequencer sqr;
shift_reg_monitor mon; //////////////////////////////////
shift_config shift_cfg;
uvm_analysis_port #(shift_reg_seq_item) agt_ap;

function new(string name="shift_reg_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = shift_driver::type_id::create("shift_driver", this);
    sqr = shift_reg_sequencer::type_id::create("shift_reg_sequencer", this);
    mon = shift_reg_monitor::type_id::create("shift_reg_monitor", this); //////////////////////////////////
    shift_cfg = shift_config::type_id::create("shift_config");
    agt_ap = new("agt_ap", this);
    if(!uvm_config_db #(shift_config) :: get(this, "", "SHIFT_KEY_COBJ", shift_cfg))begin
        `uvm_fatal("build_phase", "Can't get the config in the driver")
    end
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.shift_vif = shift_cfg.shift_vif;
    mon.shift_vif = shift_cfg.shift_vif;

    driver.seq_item_port.connect(sqr.seq_item_export); // port Export COnnection 
    mon.mon_ap.connect(agt_ap);
endfunction



endclass


endpackage