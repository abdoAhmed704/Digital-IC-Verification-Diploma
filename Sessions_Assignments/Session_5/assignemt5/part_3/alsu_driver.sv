package alsu_driver_pkg;
import uvm_pkg::*;
import alsu_config_pkg::*;

`include "uvm_macros.svh"

class alsu_driver extends uvm_driver;

`uvm_component_utils(alsu_driver)

virtual alsu_if alsu_driver_vif;
alsu_config_obj alsu_config_obj_driver;

function new(string name = "alsu_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(alsu_config_obj)::get(this, "", "SHIFT_KEY_COBJ", alsu_config_obj_driver))
      `uvm_fatal("build phase", "Cannot get the virtual interface");
    
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    alsu_driver_vif = alsu_config_obj_driver.alsu_config_vif;
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
        alsu_driver_vif.rst = 1;
        alsu_driver_vif.A = 0; alsu_driver_vif.B = 0; alsu_driver_vif.cin = 0; 
        alsu_driver_vif.serial_in = 0; alsu_driver_vif.red_op_A = 0;
        alsu_driver_vif.red_op_B = 0; alsu_driver_vif.opcode = 0;
        alsu_driver_vif.bypass_A = 0; alsu_driver_vif.bypass_B = 0;
        alsu_driver_vif.direction = 0;

        @(negedge alsu_driver_vif.clk);
        
        alsu_driver_vif.rst = 0;
        repeat(100)begin
            alsu_driver_vif.A = $random; alsu_driver_vif.B = $random; alsu_driver_vif.cin = $random; 
            alsu_driver_vif.serial_in = $random; alsu_driver_vif.red_op_A = $random;
            alsu_driver_vif.red_op_B = $random; alsu_driver_vif.opcode = $random;
            alsu_driver_vif.bypass_A = $random; alsu_driver_vif.bypass_B = $random;
            alsu_driver_vif.direction = $random;
            @(negedge alsu_driver_vif.clk);
        end
        $stop;
endtask


endclass

endpackage