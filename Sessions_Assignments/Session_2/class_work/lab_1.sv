package Excerices;

class memTrans;
    rand bit [7:0] data_in;
    rand bit [3:0] address;
    constraint c {
        data_in == 5;
        address dist{4'd0:/10, [1:14] :/ 80, 4'd15:/ 10};
    }

    function void print();
    $display("data_in = %0d, address = %0d",data_in, address);
    endfunction

    function new (bit [7:0] data_in= 0, bit [3:0] address = 0);
        this.data_in = data_in;
        this.address = address;
    endfunction


endclass

endpackage