package alsu_scoreboard_pkg;
import alsu_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";

class alsu_scoreboard extends uvm_scoreboard;

`uvm_component_utils(alsu_scoreboard);

uvm_analysis_export #(alsu_seq_item) sb_export;
uvm_tlm_analysis_fifo #(alsu_seq_item) sb_fifo;

alsu_seq_item seq_item_sb;

bit [15:0] leds_tmp = 0;
bit signed [5:0] out_tmp = 0;



int error_count = 0;
int correct_count = 0;

bit red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
bit signed [1:0] cin_reg;
bit [2:0] opcode_reg;
bit signed [2:0] A_reg, B_reg;

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction
function new(string name="alsu_scoreboard", uvm_component parent = null);
    super.new(name, parent);
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        sb_fifo.get(seq_item_sb);
        ref_model(seq_item_sb);
        if (out_tmp != seq_item_sb.out || leds_tmp != seq_item_sb.leds)begin
            `uvm_error("run_phase", $sformatf("conparsion Faild, DUT: %s, and the out_tmp %0b , leds_ex = %0h", seq_item_sb.convert2string(), out_tmp, leds_tmp));
            error_count++;
        end
        else begin
            `uvm_info("run_phase", $sformatf("correct_out, %s", seq_item_sb.convert2string()) , UVM_MEDIUM);
            uvm_info("run_phase", )
        end
    end
endtask

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Total successful transaction: %0d", correct_count), UVM_MEDIUM);
    `uvm_info("report_phase", $sformatf("Total faild transaction: %0d", error_count), UVM_MEDIUM);
endfunction

endclass

task ref_model(shift_reg_seq_item seq_item_p);
    // Declare temporary variables
    bit invalid_red_op, invalid_opcode, invalid;

    // Registering logic (not sequential here, just mimic last registered inputs)
    bit rst = seq_item_p.rst;
    bit cin = seq_item_p.cin;
    bit red_op_A = seq_item_p.red_op_A;
    bit red_op_B = seq_item_p.red_op_B;
    bit bypass_A = seq_item_p.bypass_A;
    bit bypass_B = seq_item_p.bypass_B;
    bit direction = seq_item_p.direction;
    bit serial_in = seq_item_p.serial_in;
    bit [2:0] opcode = seq_item_p.opcode;
    bit signed [2:0] A = seq_item_p.A;
    bit signed [2:0] B = seq_item_p.B;
    
    // Constants (must match module)
    string INPUT_PRIORITY = "A";
    string FULL_ADDER = "ON";

    // Handle invalid
    invalid_red_op = (red_op_A | red_op_B) & (opcode[1] | opcode[2]);
    invalid_opcode = opcode[1] & opcode[2];
    invalid = invalid_red_op | invalid_opcode;

    // LEDs: only toggle on invalid; otherwise, clear
    if (invalid) begin
        leds_tmp = ~seq_item_p.leds; // Simulate blinking
    end else begin
        leds_tmp = 0;
    end

    // Main output logic
    if (bypass_A && bypass_B)
        out_tmp = (INPUT_PRIORITY == "A") ? A : B;
    else if (bypass_A)
        out_tmp = A;
    else if (bypass_B)
        out_tmp = B;
    else if (invalid)
        out_tmp = 0;
    else begin
        case (opcode)
            3'h0: begin
                if (red_op_A && red_op_B)
                    out_tmp = (INPUT_PRIORITY == "A") ? |A : |B;
                else if (red_op_A)
                    out_tmp = |A;
                else if (red_op_B)
                    out_tmp = |B;
                else
                    out_tmp = A | B;
            end
            3'h1: begin
                if (red_op_A && red_op_B)
                    out_tmp = (INPUT_PRIORITY == "A") ? ^A : ^B;
                else if (red_op_A)
                    out_tmp = ^A;
                else if (red_op_B)
                    out_tmp = ^B;
                else
                    out_tmp = A ^ B;
            end
            3'h2: begin
                if (FULL_ADDER == "ON")
                    out_tmp = A + B + cin;
                else
                    out_tmp = A + B;
            end
            3'h3: out_tmp = A * B;
            3'h4: begin
                if (direction)
                    out_tmp = {seq_item_p.out[4:0], serial_in};
                else
                    out_tmp = {serial_in, seq_item_p.out[5:1]};
            end
            3'h5: begin
                if (direction)
                    out_tmp = {seq_item_p.out[4:0], seq_item_p.out[5]};
                else
                    out_tmp = {seq_item_p.out[0], seq_item_p.out[5:1]};
            end
            default: out_tmp = 0;
        endcase
    end
endtask


endpackage