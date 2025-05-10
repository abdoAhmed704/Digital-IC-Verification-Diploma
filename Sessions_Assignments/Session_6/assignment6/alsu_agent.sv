package alsu_agent_pkg;

import alsu_driver_pkg::*;
import alsu_config_pkg::*;
import alsu_sequencer_pkg::*;
import alsu_monitor_pkg::*;
import alsu_seq_item_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_agent extends uvm_agent;
`uvm_component_utils(alsu_agent);

alsu_driver driver;
alsu_sequencer sqr;
alsu_monitor mon;
alsu_config_obj alsu_cfg;
uvm_analysis_port #(alsu_seq_item) agt_ap;


function new(string name="alsu_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction


function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    driver = alsu_driver::type_id::create("alsu_driver", this);
    sqr = alsu_sequencer::type_id::create("alsu_sequencer", this);
    mon = alsu_monitor::type_id::create("mon", this);
    alsu_cfg = alsu_config_obj::type_id::create("alsu_config");
    agt_ap = new("agt_ap", this);
    if(!uvm_config_db #(alsu_config_obj) :: get(this, "", "ALUS_OBJ_SAVED", alsu_cfg))begin
        `uvm_fatal("build_phase", "Can't get the config in the driver")
    end
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.alsu_vif = alsu_cfg.alsu_config_vif;
    mon.alsu_vif = alsu_cfg.alsu_config_vif;
    driver.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(agt_ap);
endfunction
endclass



endpackage