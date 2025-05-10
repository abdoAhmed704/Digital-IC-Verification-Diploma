package counter_pkg;

parameter WIDTH = 4;


class counter_class;
    rand bit rst_n, load_n, ce, up_down;
    rand bit [WIDTH-1:0] data_load;
    bit [WIDTH-1:0] count_out;
    bit clk;

    // code coverage
    constraint co {
        rst_n dist {1:=90, 0:=10};
        load_n dist {1:=70, 0:=30};
        ce dist {1:=70, 0:=30};
    }
    
    // function coverage 
    covergroup covCode;

    counter_2:
        coverpoint load_n iff(rst_n && !load_n){
            ignore_bins load_n = {1};
        }
    counter_3:
        coverpoint count_out iff (rst_n && ce && up_down);
    counter_3_s:
        coverpoint count_out iff (rst_n && ce && up_down){
            bins overflow = ({WIDTH{1'b1}} => 0); // transition from max to 0
        }
        
    counter_4:
        coverpoint count_out iff (rst_n && ce && !up_down);
    counter_4_s:
        coverpoint count_out iff (rst_n && ce && !up_down){
            bins overflow = (0 => {WIDTH{1'b1}}); // transition from max to 0
        }
    endgroup

    function new();
        covCode = new();
    endfunction

endclass

endpackage
