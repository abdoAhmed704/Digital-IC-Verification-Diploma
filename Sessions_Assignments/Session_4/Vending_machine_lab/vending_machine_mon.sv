////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_monitor(vending_machine_if.MON v_if);
// 1. Add the modport above
// 2. Add the monitor statement in an initial block
initial begin
    $monitor("Q_in = %0d, D_in = %0d, rstn = %0d, change = %0d, dispense = %0d", v_if.Q_in, v_if.D_in, v_if.rstn, v_if.change, v_if.dispense);
end
endmodule