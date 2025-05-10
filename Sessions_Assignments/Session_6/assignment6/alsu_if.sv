interface alsu_if(input clk);

logic cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
logic [2:0] opcode;
logic signed [2:0] A, B;
logic [15:0] leds;
logic signed [5:0] out;

endinterface : alsu_if
