package alsu_scoreboard_pkg;

import alsu_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(alsu_scoreboard)

    uvm_analysis_export #(alsu_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(alsu_seq_item) sb_fifo;

    alsu_seq_item seq_item_sb;

    bit [15:0] leds_tmp = 0;
    bit signed [5:0] out_tmp = 0;

    int error_count = 0;
    int correct_count = 0;

    function new(string name = "alsu_scoreboard", uvm_component parent = null);
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
            ref_model(seq_item_sb, out_tmp, leds_tmp);
            if (out_tmp != seq_item_sb.out || leds_tmp != seq_item_sb.leds) begin
                `uvm_error("run_phase", $sformatf("Comparison Failed. DUT: %s, Expected out = %0b, leds = %0h", seq_item_sb.convert2string(), out_tmp, leds_tmp))
                error_count++;
            end else begin
                `uvm_info("run_phase", $sformatf("Correct output: %s", seq_item_sb.convert2string()), UVM_MEDIUM)
                correct_count++;
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("Total correct transactions: %0d", correct_count), UVM_MEDIUM)
        `uvm_info("report_phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM)
    endfunction

    task ref_model(alsu_seq_item seq_item_p, output bit signed [5:0] out_ref, output bit [15:0] leds_ref);
        automatic bit invalid_red_op, invalid_opcode, invalid;
        automatic bit rst = seq_item_p.rst;
        automatic bit cin = seq_item_p.cin;
        automatic bit red_op_A = seq_item_p.red_op_A;
        automatic bit red_op_B = seq_item_p.red_op_B;
        automatic bit bypass_A = seq_item_p.bypass_A;
        automatic bit bypass_B = seq_item_p.bypass_B;
        automatic bit direction = seq_item_p.direction;
        automatic bit serial_in = seq_item_p.serial_in;
        automatic bit [2:0] opcode = seq_item_p.opcode;
        automatic bit signed [2:0] A = seq_item_p.A;
        automatic bit signed [2:0] B = seq_item_p.B;

        string INPUT_PRIORITY = "A";
        string FULL_ADDER = "ON";

        invalid_red_op = (red_op_A | red_op_B) & (opcode[1] | opcode[2]);
        invalid_opcode = opcode[1] & opcode[2];
        invalid = invalid_red_op | invalid_opcode;

        if (invalid) begin
            leds_ref = ~seq_item_p.leds;
        end else begin
            leds_ref = 0;
        end

        if (bypass_A && bypass_B)
            out_ref = (INPUT_PRIORITY == "A") ? A : B;
        else if (bypass_A)
            out_ref = A;
        else if (bypass_B)
            out_ref = B;
        else if (invalid)
            out_ref = 0;
        else begin
            case (opcode)
                3'h0: begin
                    if (red_op_A && red_op_B)
                        out_ref = (INPUT_PRIORITY == "A") ? |A : |B;
                    else if (red_op_A)
                        out_ref = |A;
                    else if (red_op_B)
                        out_ref = |B;
                    else
                        out_ref = A | B;
                end
                3'h1: begin
                    if (red_op_A && red_op_B)
                        out_ref = (INPUT_PRIORITY == "A") ? ^A : ^B;
                    else if (red_op_A)
                        out_ref = ^A;
                    else if (red_op_B)
                        out_ref = ^B;
                    else
                        out_ref = A ^ B;
                end
                3'h2: begin
                    if (FULL_ADDER == "ON")
                        out_ref = A + B + cin;
                    else
                        out_ref = A + B;
                end
                3'h3: out_ref = A * B;
                3'h4: begin
                    if (direction)
                        out_ref = {seq_item_p.out[4:0], serial_in};
                    else
                        out_ref = {serial_in, seq_item_p.out[5:1]};
                end
                3'h5: begin
                    if (direction)
                        out_ref = {seq_item_p.out[4:0], seq_item_p.out[5]};
                    else
                        out_ref = {seq_item_p.out[0], seq_item_p.out[5:1]};
                end
                default: out_ref = 0;
            endcase
        end
    endtask

endclass

endpackage
