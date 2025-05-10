package shift_reg_scoreboard_pkg;
import shift_reg_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"



class shift_reg_scoreboard extends uvm_scoreboard;
`uvm_component_utils(shift_reg_scoreboard)

uvm_analysis_export #(shift_reg_seq_item) sb_export;
uvm_tlm_analysis_fifo #(shift_reg_seq_item) sb_fifo;

shift_reg_seq_item seq_item_sb;

logic [5:0] dataout_ref;

int error_count = 0;
int correct_count = 0;

function new(string name="shift_reg_scoreboard", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo", this);
    // seq_item_sb = shift_reg_seq_item::type_id::create("shift_reg_seq_item"); // NOOOOO WE INIT IT IN THE RUN PHASE STUPID~~~

endfunction

function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        
        sb_fifo.get(seq_item_sb);
        ref_model(seq_item_sb);

        if (seq_item_sb.dataout != dataout_ref) begin
            `uvm_error("run_phase", $sformatf("conparsion Faild, DUT: %s, and the ref out %0b", seq_item_sb.convert2string(), dataout_ref));
            error_count++;
        end
        else begin
            `uvm_info("run_phase", $sformatf("Correct dataout_ref: %s", seq_item_sb.convert2string()), UVM_MEDIUM);
            correct_count++;
        end
    end
endtask

task ref_model(shift_reg_seq_item seq_item_rf);
    if (seq_item_rf.reset)
        dataout_ref = 0;
    else
        if (seq_item_rf.mode) // rotate
            if (seq_item_rf.direction) // left
                dataout_ref = {seq_item_rf.datain[4:0], seq_item_rf.datain[5]};
            else
                dataout_ref = {seq_item_rf.datain[0], seq_item_rf.datain[5:1]};
        else // shift
            if (seq_item_rf.direction) // left
                dataout_ref = {seq_item_rf.datain[4:0], seq_item_rf.serial_in};
            else
                dataout_ref = {seq_item_rf.serial_in, seq_item_rf.datain[5:1]};
endtask

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Total successful transaction: %0d", correct_count), UVM_MEDIUM);
    `uvm_info("report_phase", $sformatf("Total faild transaction: %0d", error_count), UVM_MEDIUM);
endfunction

endclass

endpackage


/*


module shift_reg (clk, reset, serial_in, direction, mode, datain, dataout);
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;

always @(posedge clk or posedge reset) begin
   if (reset)
      dataout = 0;
   else
      if (mode) // rotate
         if (direction) // left
            dataout = {datain[4:0], datain[5]};
         else
            dataout = {datain[0], datain[5:1]};
      else // shift
         if (direction) // left
            dataout = {datain[4:0], serial_in};
         else
            dataout = {serial_in, datain[5:1]};
end
endmodule

**/