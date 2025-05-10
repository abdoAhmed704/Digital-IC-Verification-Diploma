import uvm_pkg::*;
`include "uvm_macros.svh"

import fifo_test_pkg::*;

module top();

  bit clk;
  initial begin
    forever 
      #2 clk = ~clk;
  end
  // fifo_internal_interface fifo_internal_interface_ins(clk);
  fifo_interface fifo_interface_ins (clk);

  FIFO dut  (fifo_interface_ins);
  
  bind FIFO fifo_sva sva_f (.fifo_interface_ins(fifo_if));

  initial begin
    uvm_config_db #(virtual fifo_interface)::set (null, "uvm_test_top", "FIFO_KEY_VIF", fifo_interface_ins);
    run_test("fifo_test");
  end

endmodule
