////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
interface vending_machine_if(input clk);
// 1. Add the parameters (WAIT = 0, Q_25 = 1, Q_50 =2)
parameter WAIT = 2'b00;
parameter Q_25 = 2'b01;
parameter Q_50 = 2'b11;


logic Q_in, D_in, rstn, change, dispense;


modport MON (input Q_in, D_in, rstn, change, dispense, clk);
modport DUT (input Q_in, D_in, rstn, clk, output change, dispense);
modport TEST (input clk, change, dispense, output Q_in, D_in, rstn);

endinterface