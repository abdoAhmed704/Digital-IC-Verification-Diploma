module fifo_sva(fifo_interface fifo_interface_ins);

	always_comb begin
    	if (!fifo_interface_ins.rst_n)
        	Reset_Behavior: assert final ((FIFO.wr_ptr == 0 && FIFO.rd_ptr == 0 && FIFO.count == 0)); 
	end
	
	property pr4;
		@(posedge fifo_interface_ins.clk) disable iff(!fifo_interface_ins.rst_n)
			(FIFO.count == 0) |-> fifo_interface_ins.empty;
	endproperty
	empty_assert: assert property(pr4);
	empty_cover: cover property(pr4);

	
property pr1;
    @(posedge fifo_interface_ins.clk) disable iff(!fifo_interface_ins.rst_n)
        (!fifo_interface_ins.full && fifo_interface_ins.wr_en) |=> fifo_interface_ins.wr_ack;
endproperty
write_acknowledge_assert: assert property (pr1);
Write_Acknowledge_cover:  cover property (pr1);

/////////////////////

property pr2;
    @(posedge fifo_interface_ins.clk) disable iff(!fifo_interface_ins.rst_n)
        (fifo_interface_ins.full & fifo_interface_ins.wr_en) |=> fifo_interface_ins.overflow;
endproperty
overflow_assert : assert property(pr2);
overflow_cover : cover property(pr2);

////////////////////

property pr3;
    @(posedge fifo_interface_ins.clk) disable iff(!fifo_interface_ins.rst_n) 
        (fifo_interface_ins.empty && fifo_interface_ins.rd_en) |=> fifo_interface_ins.underflow;
endproperty
underflow_assert : assert property(pr3);
underflow_cover : cover property(pr3);

///////////////////
property pr5;
    @(posedge fifo_interface_ins.clk) disable iff(!fifo_interface_ins.rst_n)
        (FIFO.count == FIFO.FIFO_DEPTH) |-> fifo_interface_ins.full;
endproperty
full_assert: assert property(pr5);
full_cover: cover property(pr5);

////////////////////

property pr6;
    @(posedge fifo_interface_ins.clk) disable iff(!fifo_interface_ins.rst_n)
        (FIFO.count == FIFO.FIFO_DEPTH - 1) |-> fifo_interface_ins.almostfull;
endproperty
almsotfull_assert: assert property(pr6);
almsotfull_cover: cover property(pr6);

////////////////////

property pr7;
    @(posedge fifo_interface_ins.clk) disable iff(!fifo_interface_ins.rst_n)
        (FIFO.count == 1) |-> fifo_interface_ins.almostempty;
endproperty
almsotempty_assert: assert property(pr7);
almsotempty_cover: cover property(pr7);
// Read pointer wraparound after 8 reads

property read_pointer_wraparound;
@(posedge fifo_interface_ins.clk) disable iff(!fifo_interface_ins.rst_n)
(FIFO.rd_ptr == 7 && fifo_interface_ins.empty)
|=> (FIFO.rd_ptr == 0)[->1];
endproperty
rd_ptr_wrap_asset: assert property(read_pointer_wraparound);
rd_ptr_wrap_cover: cover property(read_pointer_wraparound);
// Pointers and FIFO.counter must remain in valid range
endmodule