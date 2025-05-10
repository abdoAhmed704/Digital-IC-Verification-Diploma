package fifo_scoreboard_pkg;

import fifo_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_export #(fifo_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;

    fifo_seq_item seq_item_sb;

    logic [FIFO_WIDTH-1:0] data_out_ref;
    bit [FIFO_WIDTH-1:0] fifo_ref[$];

    int error_count = 0;
    int correct_count = 0;


    function new(string name = "fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo = new("sb_fifo", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            reference_model(seq_item_sb);
            if (data_out_ref !== seq_item_sb.data_out)begin

                `uvm_error("run_phase", $sformatf("Error, DUT out = %0d, data_out_ref =%0d", seq_item_sb.data_out, data_out_ref))
                error_count++;
                // $display("===============  ERROR  ==========================");
                // $display("scoreboard_ERROR: output => %0d not equal the ref Out => %0d", seq_item_sb.data_out, data_out_ref);
                // $display("When rst_n: %0d, wr_en: %0d, rd_en: %0d, data_in: %0d", seq_item_sb.rst_n, seq_item_sb.wr_en, seq_item_sb.rd_en, seq_item_sb.data_in);
                // $display("===================================================");
            end
            else begin
                `uvm_info("run_phase", $sformatf("Correct output: %s", seq_item_sb.convert2string()), UVM_MEDIUM)
                correct_count++;
                // $display("================  Correct   ======================");
                // $display("Correct:: output => %0d equal the ref Out => %0d", seq_item_sb.data_out, data_out_ref);
                // $display("When rst_n: %0d, wr_en: %0d, rd_en: %0d, data_in: %0d", seq_item_sb.rst_n, seq_item_sb.wr_en, seq_item_sb.rd_en, seq_item_sb.data_in);
                // $display("=======================================================");
            end

        end


    endtask
    
    function void reference_model(fifo_seq_item seq_item);
        if (!seq_item.rst_n)begin
            // data_out_ref = 0;
            fifo_ref.delete();
        end
        else begin
            if (seq_item.wr_en && !seq_item.rd_en) begin
                if (!isFull())begin
                    fifo_ref.push_back(seq_item.data_in);
                    $display("HERE in pushing 1");
                end
            end
            else if (seq_item.rd_en && !seq_item.wr_en) begin
                    if (!isEmpty())begin
                        data_out_ref = fifo_ref.pop_front();
                        $display("HERE in popping 1");
                        
                    end
                    else 
                        $display("EMpty");
                end
            else if (seq_item.wr_en && seq_item.rd_en) begin
                if (!isEmpty() && !isFull()) begin
                    data_out_ref = fifo_ref.pop_front();
                    fifo_ref.push_back(seq_item.data_in);
                    $display("HERE in pushing popping");
                end
                else if (isEmpty()) begin
                    fifo_ref.push_back(seq_item.data_in);
                    $display("HERE in pushing 2");
                end
                else if (isFull()) begin
                    data_out_ref = fifo_ref.pop_front();
                    $display("HERE in popping 2");
               
                end
            end
        end
    
        `ifdef DEBUG
            $display("------------------INSIDE GOLDEN MODEL--------------");
            $display("When rst_n: %0d, wr_en: %0d, rd_en: %0d, data_in: %0d", seq_item.rst_n, seq_item.wr_en, seq_item.rd_en, seq_item.data_in);
            $display("size of queue: %0d", fifo_ref.size());
            $display("(1)%0d \n(2)%0d \n(3)%0d \n(4)%0d \n(5)%0d", fifo_ref[0], fifo_ref[1], fifo_ref[2], fifo_ref[3], fifo_ref[4]);
            $display("(6)%0d \n(7)%0d \n(8)%0d \n(9)%0d \n(10)%0d", fifo_ref[5], fifo_ref[6], fifo_ref[7], fifo_ref[8], fifo_ref[9]);
            $display("(11)%0d \n(12)%0d", fifo_ref[10], fifo_ref[11]);
            $display("---------------------------------------------------");
        `endif
    endfunction

    function bit isFull();
        if (fifo_ref.size() == FIFO_DEPTH)
            return 1;
        return 0;
    endfunction
    
    function bit isEmpty();
        if (fifo_ref.size() == 0)
            return 1;
        return 0;
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("Total correct transactions: %0d", correct_count), UVM_MEDIUM)
        `uvm_info("report_phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM)
    endfunction
endclass

endpackage

