module my_mem_tb;

localparam TESTS = 100;

// Dynamic arrays
bit [15:0] address_array[];
bit [7:0] data_to_write_array[];

//associative array
bit [8:0] data_read_expect_assoc[int];
bit [8:0] data_read_queue[$];
bit clk;
bit write;
bit read;
bit [7:0] data_in;
bit [15:0] address;
logic [8:0] data_out;

int d;
int itrate = TESTS;

int ErrorCounter = 0;
int CorrectCorrect = 0;

my_mem RAM (.*);


initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk; 
    end
end

task stimulus_gen;
    for(int i = 0; i < TESTS; i++)begin
        address_array[i] = $random;
        data_to_write_array[i] = $random;

    end
endtask

task golden_model;
    for(int i = 0; i < TESTS; i++)begin
        data_read_expect_assoc[address_array[i]] = {^data_to_write_array[i], data_to_write_array[i]};
    end
endtask

task check9Bits(bit [15:0] address_array_);
    @(negedge clk);
    if (data_out !== data_read_expect_assoc[address_array_])begin
        $display("error:  when %0t    write = %0d, read = %0d, data_in = %0d, address = %0d, NEW_address_array_ = %0d, data_out = %0d, compared_value = %0d", $time, write, read, data_in, address,address_array_,  data_out, data_read_expect_assoc[address_array_]);
        ErrorCounter++;
    end
    else begin
        CorrectCorrect++;
        $display("%0t    write = %0d, read = %0d, data_in = %0d, address = %0d, NEW_address_array_ = %0d, data_out = %0d, compared_value = %0d",
            $time, write, read, data_in, address, address_array_, data_out, data_read_expect_assoc[address_array_]);
        end
endtask

initial begin

    address_array = new[TESTS];
    data_to_write_array = new[TESTS];

    stimulus_gen;
    golden_model;
    
    // Writing 
    write = 1;
    read = 0;
    for (int i = 0; i < TESTS; i++)begin
        address = address_array[i];
        data_in = data_to_write_array[i];
        @(negedge clk);
    end

    //Readding
    write = 0;
    read = 1;
    for(int i = 0; i < TESTS; i++)begin
        address = address_array[i];
        check9Bits(address_array[i]);
        data_read_queue.push_back(data_out);
    end

    while (itrate >= 0) begin
        d = data_read_queue.pop_front();
        $display("%0d)'th data  = %d", itrate, d);
        itrate--;
    end

    $display("Error count   = %0d", ErrorCounter);
    $display("Correct count = %0d", CorrectCorrect);
    $stop;
end

endmodule