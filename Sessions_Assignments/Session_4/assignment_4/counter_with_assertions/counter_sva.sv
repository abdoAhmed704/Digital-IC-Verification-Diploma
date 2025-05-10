module counter_sva(counter_if.DUT c_if);

always_comb begin
    if (!c_if.rst_n)
        a_reset: assert final ((wr_ptr == 0 && rd_ptr == 0 && count == 0)); // edit this
end

property load_p;
    @(posedge c_if.clk) disable iff(!c_if.rst_n) !c_if.load_n |=> (c_if.count_out == $past(c_if.data_load));
endproperty

property out_not_changes_p;
    @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.load_n && !c_if.ce) |=> (c_if.count_out == $past(c_if.count_out));
endproperty

property increment_out_p;
    @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.load_n && c_if.ce && c_if.up_down) |=> (c_if.count_out == ($past(c_if.count_out) + 1'b1));
endproperty

property decrement_out_p;
    @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.load_n && c_if.ce && !c_if.up_down) |=> (c_if.count_out == ($past(c_if.count_out) - 1'b1));
endproperty

property max_count_p;
    @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.count_out == {c_if.WIDTH{1'b1}} ) |-> (c_if.max_count == 1'b1);
endproperty

property zero_p;
    @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.count_out == {c_if.WIDTH{1'b0}} )  |-> (c_if.zero == 1'b1);
endproperty

Assert_load_p:            assert property (load_p);
Assert_out_not_changes_p: assert property (out_not_changes_p);
Assert_increment_out_p:   assert property (increment_out_p);
Assert_decrement_out_p:   assert property (decrement_out_p);
Assert_zero_p:            assert property (zero_p);
Assert_max_count_p:       assert property (max_count_p);

Cover_load_p:            cover property (load_p);
Cover_out_not_changes_p: cover property (out_not_changes_p);
Cover_increment_out_p:   cover property (increment_out_p);
Cover_decrement_out_p:   cover property (decrement_out_p);
Cover_zero_p:            cover property (zero_p);
Cover_max_count_p:       cover property (max_count_p);


endmodule