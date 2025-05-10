import uvm_pkg::*;
`include "uvm_macros.svh"

import alsu_test_pkg::*;

module top();

  bit clk;
  initial begin
    forever 
      #1 clk = ~clk;
  end

  alsu_if alsu_if (clk);

  ALSU dut  (alsu_if.A, alsu_if.B, alsu_if.cin, 
            alsu_if.serial_in, alsu_if.red_op_A,
            alsu_if.red_op_B, alsu_if.opcode,
            alsu_if.bypass_A, alsu_if.bypass_B,
            alsu_if.clk, alsu_if.rst, alsu_if.direction,
            alsu_if.leds, alsu_if.out);
  
  initial begin
    uvm_config_db #(virtual alsu_if) :: set (null, "uvm_test_top", "ALSU_KEY_VIF", alsu_if);
    run_test("alsu_test");
  end

endmodule
