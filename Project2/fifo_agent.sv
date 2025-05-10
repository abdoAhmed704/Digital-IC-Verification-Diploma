package fifo_agent_pkg;

import fifo_config_pkg::*;
import fifo_driver_pkg::*;
import fifo_sequencer_pkg::*;
import fifo_monitor_pkg::*;
import fifo_seq_item_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_agent extends uvm_agent;
`uvm_component_utils(fifo_agent);

fifo_driver driver;
fifo_sequencer sqr;
fifo_monitor mon;
fifo_config fifo_cfg;

uvm_analysis_port #(fifo_seq_item) agt_ap;

function new(string name="fifo_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction


function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    driver = fifo_driver::type_id::create("fifo_driver", this);
    sqr = fifo_sequencer::type_id::create("fifo_sequencer", this);
    mon = fifo_monitor::type_id::create("fifo_monitor", this);
    fifo_cfg = fifo_config::type_id::create("fifo_config");
    agt_ap = new("agt_ap", this);
    if(!uvm_config_db #(fifo_config) :: get(this, "", "FIFO_OBJ_SAVED", fifo_cfg))begin
        `uvm_fatal("build_phase", "Can't get the config in the driver")
    end
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.fifo_vif = fifo_cfg.fifo_config_vif;
    mon.fifo_vif = fifo_cfg.fifo_config_vif;
    driver.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(agt_ap);
endfunction


endclass


endpackage