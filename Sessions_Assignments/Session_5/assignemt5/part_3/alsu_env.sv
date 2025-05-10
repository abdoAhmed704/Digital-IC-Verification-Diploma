package alsu_env_pkg;

import alsu_driver_pkg::*;
import uvm_pkg::*;  
`include "uvm_macros.svh"

class alsu_env extends uvm_component;
    `uvm_component_utils(alsu_env)

    alsu_driver driver;

    function new (string name = "alsu_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = alsu_driver::type_id::create("alsu_driver", this);
    endfunction
endclass

endpackage