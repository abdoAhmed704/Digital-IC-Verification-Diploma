assert property (@(posedge clk) a  |-> ##2 b);


assert property (@(posedge clk) (a && b) |-> ##[1:3] c);


sequence s11b;
    ##2 ~b;
endsequence


property property_decoder;
@(posedge clk) $onehot(Y);
endproperty


property property_decoder;
@(posedge clk) ($countones(D) == 0) |-> ##2 !valid; 
endproperty

