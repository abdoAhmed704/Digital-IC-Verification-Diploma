////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_interface.DUT fifo_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
	end
	else if (fifo_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifo_if.wr_ack <= 0; 
		if (fifo_if.full & fifo_if.wr_en)
			fifo_if.overflow <= 1;
		else
			fifo_if.overflow <= 0;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
			count <= count - 1;
	end
end

assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
assign fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0; 
assign fifo_if.almostfull = (count == FIFO_DEPTH-2)? 1 : 0; 
assign fifo_if.almostempty = (count == 1)? 1 : 0;



////////////////////////////////////////////////////////////////////////////////////
////////////////////////   assertions    //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

`ifdef SIM


	always_comb begin
    	if (!fifo_if.rst_n)
        	Reset_Behavior: assert final ((wr_ptr == 0 && rd_ptr == 0 && count == 0)); 
	end

    /////////////////////
    property pr1;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
			(!fifo_if.full && fifo_if.wr_en) |=> fifo_if.wr_ack;
    endproperty
    write_acknowledge_assert: assert property (pr1);
    Write_Acknowledge_cover:  cover property (pr1);

    /////////////////////
    
    property pr2;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
            (fifo_if.full & fifo_if.wr_en) |=> fifo_if.overflow;
	endproperty
	overflow_assert : assert property(pr2);
	overflow_cover : cover property(pr2);

    ////////////////////

    property pr3;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) 
            (fifo_if.empty && fifo_if.rd_en) |=> fifo_if.underflow;
	endproperty
	underflow_assert : assert property(pr3);
	underflow_cover : cover property(pr3);

    ////////////////////


    property pr4;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
			(count == 0) |-> fifo_if.empty;
    endproperty
    empty_assert: assert property(pr4);
    empty_cover: cover property(pr4);


    ///////////////////

    property pr5;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
			(count == FIFO_DEPTH) |-> fifo_if.full;
    endproperty
    full_assert: assert property(pr5);
    full_cover: cover property(pr5);

    ////////////////////

    property pr6;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
			(count == FIFO_DEPTH - 1) |-> fifo_if.almostfull;
    endproperty
    almsotfull_assert: assert property(pr6);
    almsotfull_cover: cover property(pr6);
    
    ////////////////////

    property pr7;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
			(count == 1) |-> fifo_if.almostempty;
    endproperty
    almsotempty_assert: assert property(pr7);
    almsotempty_cover: cover property(pr7);


	////////////////////

	// Write pointer wraparound after 8 writes
	property write_pointer_wraparound;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
		// Sample on first write at 0, then check if 8 valid writes return it to 0
		(wr_ptr == 0 && fifo_if.wr_en && !fifo_if.full)
		|=> ((fifo_if.wr_en && !fifo_if.full)[->1]);
	endproperty
	wr_ptr_wrap_assert: assert property(write_pointer_wraparound);
	wr_ptr_wrap_cover: cover property(write_pointer_wraparound);

	// Read pointer wraparound after 8 reads
	property read_pointer_wraparound;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
		(rd_ptr == 0 && fifo_if.rd_en && !fifo_if.empty)
		|=> ((fifo_if.rd_en && !fifo_if.empty)[->1]);
	endproperty
	rd_ptr_wrap_asset: assert property(read_pointer_wraparound);
	rd_ptr_wrap_cover: cover property(read_pointer_wraparound);

	// Pointers and counter must remain in valid range
	property pointer_threshold;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
		(wr_ptr < FIFO_DEPTH) && (rd_ptr < FIFO_DEPTH) && (count <= FIFO_DEPTH);
	endproperty
	ptr_threshold_assert: assert property(pointer_threshold);
	ptr_threshold_cover: cover property(pointer_threshold);


`endif 




endmodule