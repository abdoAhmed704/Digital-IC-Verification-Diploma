module tests_dyn();
    int dyn_arr1[], dyn_arr2[];

initial begin
  	dyn_arr2 = '{9,1,8,3,4,4};
    $display("%p", dyn_arr2);
    
    dyn_arr1 = new[6];

    foreach (dyn_arr1[i]) begin
        dyn_arr1[i] = i;
    end

    $display("%p, %0d", dyn_arr1, dyn_arr1.size);

    dyn_arr1.delete();
    $display("%p, %0d", dyn_arr1, dyn_arr1.size);

    // reverse dyn_arr2
    dyn_arr2.reverse();
    $display("reverse Array = %p", dyn_arr2);

    // sort dyn_arr2
    dyn_arr2.sort();
    $display("Sorted Array = %p", dyn_arr2);

    //reverse sort dyn_arr
    dyn_arr2.reverse();
    $display("reverse sort Array = %p", dyn_arr2);

    //shuffle  dyn_arr2
    dyn_arr2.shuffle();
    $display("shuffle Array = %p", dyn_arr2);
end

endmodule