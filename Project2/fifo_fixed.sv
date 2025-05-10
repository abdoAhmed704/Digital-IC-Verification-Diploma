////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_interface fifo_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
        fifo_if.wr_ack <= 0; /// should make it 0 again if rst_n active
		fifo_if.overflow <= 0;
	end
	else if (fifo_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		// fifo_if.data_out <= 123;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifo_if.wr_ack <= 0; 
		if (fifo_if.full && fifo_if.wr_en) /// fix & to &&
			fifo_if.overflow <= 1;
		else
			fifo_if.overflow <= 0;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
		fifo_if.underflow <= 0;
		// fifo_if.data_out <= 0;
	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin
		if(fifo_if.empty && fifo_if.rd_en)begin
			fifo_if.underflow <= 1;
		end
		else begin
			fifo_if.underflow <= 0;
		end
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
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.empty) /////// fixing here
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.full)
			count <= count - 1;
	end
end

assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
// assign fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0;  ////// SHOULD BE SEQ not COMBINATIONAL
assign fifo_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; /////// FIXING  
assign fifo_if.almostempty = (count == 1)? 1 : 0;


endmodule