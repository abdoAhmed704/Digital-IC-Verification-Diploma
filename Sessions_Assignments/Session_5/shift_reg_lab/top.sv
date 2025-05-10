////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pkg::*;

module top();
  // Example 1
  // Clock generation
  // Instantiate the interface and DUT
  // run test using run_test task
  bit clk;
  initial begin
    forever 
      #1 clk = ~clk;
  end

  shift_reg_if shift_if (clk);

  shift_reg dut(shift_if.clk, shift_if.reset, shift_if.serial_in, shift_if.direction, shift_if.mode, shift_if.datain, shift_if.dataout);
  
  initial begin

    uvm_config_db #(virtual shift_reg_if) :: set (null, "uvm_test_top", "SHIFT_KEY_VIF", shift_if);
    run_test("shift_reg_test");
  end

  // Example 2
  // Set the virtual interface for the uvm test
endmodule