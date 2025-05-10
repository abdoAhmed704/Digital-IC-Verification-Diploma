////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_top();
// 1. Generate the clock
bit clk;
initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

// 2. instantiate the interface, and pass the clock
vending_machine_if v_if(clk);

// 3. instantiate the tb, DUT, monitor, and pass the interface
vending_machine_tb tb (v_if);
vending_machine dut (v_if);
vending_machine_monitor mont (v_if);

// 4. bind the SVA module to the design, and pass the interface

bind vending_machine vending_machine_sva v_m_sva_inst (v_if);

endmodule