import ALSU_pkg::*;

module ALSU_tb;
  parameter INPUT_PRIORITY = "A";
  parameter FULL_ADDER = "ON";
  bit clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
  bit signed [2:0] A, B;
  opcode_e opcode;
  bit [15:0] leds_exp;
  logic [15:0] leds;
  logic signed [5:0] out;
  bit signed [5:0] out_exp;

  bit red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
  bit signed [1:0] cin_reg;
  bit [2:0] opcode_reg;
  bit signed [2:0] A_reg, B_reg;

  int error_count = 0;
  int correct_count = 0;
  int flag = 0;
  ALSU_inputs ALSU_obj = new();

  ALSU al (A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction, leds, out);

  // Clock Generation
  initial begin
    clk = 0;
    forever
      #1 clk = ~clk;
  end

  initial begin
    assert_reset();
    // start randomization

    forcing_opcode;
    ALSU_obj.array_con.constraint_mode(0);
    repeat (20000) begin
      assert(ALSU_obj.randomize());
      cin = ALSU_obj.cin;
      red_op_A = ALSU_obj.red_op_A;
      red_op_B = ALSU_obj.red_op_B;
      bypass_A = ALSU_obj.bypass_A;
      bypass_B = ALSU_obj.bypass_B;
      direction = ALSU_obj.direction;
      serial_in = ALSU_obj.serial_in;
      opcode = ALSU_obj.opcode;
      A = ALSU_obj.A;
      B = ALSU_obj.B;
      rst = ALSU_obj.rst;
      if (ALSU_obj.rst) begin
        check_rst();
        reset_internals();
      end
      else begin
        golden_model();
        check_results();
        if(!bypass_A || !bypass_B)
          ALSU_obj.cvr_gp.sample();
        end
      
    end
    
    ALSU_obj.constraint_mode(0);
    ALSU_obj.array_con.constraint_mode(1);

    {red_op_A, red_op_B, rst, bypass_A, bypass_B} = 5'b00000;

    repeat(2000)begin
      cin = ALSU_obj.cin;
      direction = ALSU_obj.direction;
      serial_in = ALSU_obj.serial_in;
      A = ALSU_obj.A;
      B = ALSU_obj.B;

      for(int i = 0; i  <= 5; i++)begin
        opcode = ALSU_obj.opcode_array[i];
        ALSU_obj.opcode = ALSU_obj.opcode_array[i];
        golden_model();
        check_results();
        ALSU_obj.cvr_gp.sample();

      end
    end
    $display("correct_count = %0d and error_count = %0d", correct_count, error_count);
    $stop;
  end

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

  task golden_model();
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

  task update_internals();
    cin_reg = cin;
    red_op_B_reg = red_op_B;
    red_op_A_reg = red_op_A;
    bypass_B_reg = bypass_B;
    bypass_A_reg = bypass_A;
    direction_reg = direction;
    serial_in_reg = serial_in;
    opcode_reg = opcode;
    A_reg = A;
    B_reg = B;
  endtask

  task assert_reset();
    // reset asserted
    rst = 1;
    @(negedge clk);
    check_rst();
    rst = 0;
  endtask

  task check_rst();
    @(negedge clk);
    if (out != 0 || leds != 0) begin
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

  // check_results task
  task check_results();
    @(negedge clk);
    if ((out == out_exp) && (leds == leds_exp)) begin
      correct_count++;
    end
    else begin
      error_count++;
      
      $display("%0t : error when A =0d '%0d , B =0d '%0d , Cin =0d '%0d, serial_in =0d '%0d, red_op_A =0d '%0d, red_op_B =0d '%0d, bypass_A =0d '%0d, bypass_B =0d '%0d, direction =0d '%0d, opcode =0d '%0d",
              $time, A_reg, B_reg, cin_reg, serial_in_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, opcode_reg);
      $display("leds =16'h%0h, leds_exp = 6'h%0h and out =0d '%0d , out_exp = 0d '%0d", leds, leds_exp, out, out_exp);
      $stop;
    end
  endtask


  task forcing_opcode;
      repeat(8)begin
        assert(ALSU_obj.randomize());
        opcode = ALSU_obj.opcode;
        $display("%0t opcode inside the class = %0d", $time,  ALSU_obj.opcode);
        $display("%0t size = %0d", $time,  ALSU_obj.fixed_tr_array.size());
        ALSU_obj.cvr_gp.sample();
      end

  endtask
endmodule