package counter_pkg;

parameter WIDTH = 4;

class counter_class;
    rand bit rst_n, load_n, ce, up_down;
    rand bit [WIDTH-1:0] data_load;

    constraint co {
        rst_n dist {1:=90, 0:=10};
        load_n dist {1:=70, 0:=30};
        ce dist {1:=70, 0:=30};
    }

endclass

endpackage