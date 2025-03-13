import Excerices::*;

module obj_tb();

memTrans a = new;
int i = 0;

initial begin
    for (i = 0; i < 20; i++) begin
        assert(a.randomize());
        a.print();
    end
end


endmodule