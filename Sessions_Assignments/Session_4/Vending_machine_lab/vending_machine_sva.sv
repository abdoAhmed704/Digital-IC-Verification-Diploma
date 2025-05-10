////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////

module vending_machine_sva(vending_machine_if.DUT v_if);

property p_dollar;
    @(posedge v_if.clk)  v_if.D_in |-> (v_if.dispense && v_if.change);
endproperty


property p_quarter_dispense;
    @(posedge v_if.clk) $rose(v_if.Q_in) |=> ##2 v_if.dispense;
endproperty


property p_quarter_if_change;
    @(posedge v_if.clk) v_if.Q_in |-> !(v_if.change);
endproperty


Dollar_assertion: assert property(p_dollar);
Quarter_dispense_assertion: assert property(p_quarter_dispense);
Quarter_if_change_assertion: assert property(p_quarter_if_change);


Dollar_cover: cover property(p_dollar);
Quarter_dispense_cover: cover property(p_quarter_dispense);
Quarter_if_change_cover: cover property(p_quarter_if_change);

endmodule 