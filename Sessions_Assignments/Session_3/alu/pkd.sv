package package_name;

typedef enum {ADD, SUB, MULT, DIV} opcode_e;

class Transaction;
    rand opcode_e opcode;
    rand byte operand1;
    rand byte operand2;
    bit clk;
    static bit neg_done = 0;
    static bit zero_done = 0;
    static bit pos_done = 0;

    constraint cover_values {
        if (!neg_done)
            operand1 == -128;
        else if (!zero_done)
            operand1 == 0;
        else if (!pos_done)
            operand1 == 127;
    }

    function void post_randomize();
        if (operand1 == -128) neg_done = 1;
        if (operand1 == 0)    zero_done = 1;
        if (operand1 == 127)  pos_done = 1;
    endfunction

    covergroup cg @(posedge clk);
        coverpoint opcode {
            bins ADD_SUB = {ADD , SUB};
            bins ADD_F_SUB = (ADD => SUB);
            illegal_bins div = {DIV};
        }
        coverpoint operand1{
            bins MAX_NEG = {-128};
            bins MAX_POS = {+127};
            bins ZERO = {0};
        }
    endgroup
    function new();
        cg = new();
    endfunction
endclass
endpackage
