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

int error_count = 0;
int correct_count = 0;

logic [5:0] out_exp;
logic [5:0] leds_exp;

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

        if(seq_item_sb.rst)begin
            check_rst();
            reset_internals();
        end
        else begin
            ref_model();
            check_results();
        end

    end
endtask

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Total successful transaction: %0d", correct_count), UVM_MEDIUM);
    `uvm_info("report_phase", $sformatf("Total faild transaction: %0d", error_count), UVM_MEDIUM);
endfunction


task ref_model();
    // Handle leds_exp
    if(is_invalid())begin
      if (leds_exp == 16'hFFFF)
        leds_exp = ~leds_exp;
      else
        leds_exp = 16'hFFFF;
    end
    else
      leds_exp = 0;

    // Handle bypass, invalid and valid opcodes for out_exp

    // Check Bypass
    if (bypass_A_reg)
      out_exp = A_reg;
    else if (bypass_B_reg)
      out_exp = B_reg;

    // Check invalid
    else if (is_invalid())
      out_exp = 0;

    // Valid opcodes
    else begin
      // OR
      if (opcode_reg == OR) begin
        if (red_op_A_reg)
          out_exp = |A_reg;
        else if (red_op_B_reg)
          out_exp = |B_reg;
        else
          out_exp = A_reg | B_reg;
      end

      // XOR
      else if (opcode_reg == XOR) begin
        if (red_op_A_reg)
          out_exp = ^A_reg;
        else if (red_op_B_reg)
          out_exp = ^B_reg;
        else
          out_exp = A_reg ^ B_reg; // Fixed from multiplication to XOR
      end

      // ADD
      else if (opcode_reg == ADD)begin
        if (FULL_ADDER == "ON")
          out_exp = A_reg + B_reg + cin_reg;
        else
          out_exp = A_reg + B_reg;
      end

      // MULT
      else if (opcode_reg == MULT)begin
        out_exp = A_reg * B_reg; // Fixed typo from '-' to '='
      end

      // SHIFT
      else if (opcode_reg == SHIFT) begin
        if (direction_reg)
          out_exp = {out_exp[4:0], serial_in_reg};
        else
          out_exp = {serial_in_reg, out_exp[5:1]};
      end

      // ROTATE
      else if (opcode_reg == ROTATE) begin
        if (direction_reg)
          out_exp = {out_exp[4:0], out_exp[5]};
        else
          out_exp = {out_exp[0], out_exp[5:1]};
      end
    end
    update_internals();

endtask


///////////////////////////////////////////////////////////
task check_rst();
    @(negedge seq_item_sb.clk);
    if (seq_item_sb.out != 0 || seq_item_sb.leds != 0) begin
      $display("Error in reset");
      error_count++;
    end
    else
      correct_count++;
    reset_internals();
endtask


task reset_internals();
    {red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg} = 6'b00_0000;
    cin_reg = 2'b00;
    opcode_reg = 3'b00;
    {A_reg, B_reg} = 2'b00;
endtask

task check_results();
    @(negedge seq_item_sb.clk);
    if ((seq_item_sb.out == out_exp) && (seq_item_sb.leds == leds_exp)) begin
        correct_count++;
    end
    else begin
        error_count++;
        `uvm_error("run_phase", $sformatf("%s, leds_exp = 6'h%0h , out_exp = 0d '%0d", seq_item_sb.convert2string(), leds_exp, out_exp))
    end
endtask

task update_internals();
    cin_reg = seq_item_sb.cin;
    red_op_B_reg = seq_item_sb.red_op_B;
    red_op_A_reg = seq_item_sb.red_op_A;
    bypass_B_reg = seq_item_sb.bypass_B;
    bypass_A_reg = seq_item_sb.bypass_A;
    direction_reg = seq_item_sb.direction;
    serial_in_reg = seq_item_sb.serial_in;
    opcode_reg = seq_item_sb.opcode;
    A_reg = seq_item_sb.A;
    B_reg = seq_item_sb.B;
endtask

function bit is_invalid();
    // invalid case 1
    if (opcode_reg == INVALID_6 || opcode_reg == INVALID_7)
        return 1;
    // invalid case 2
    else if ((opcode_reg > 3'b001) && (red_op_A_reg || red_op_B_reg))
        return 1;
    else
        return 0;
endfunction

//////////////////////////////////////////////////////////
endclass

endpackage