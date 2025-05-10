package FIFO_scoreboard_pkg;
import shared_pkg::*;
import FIFO_transaction_pkg::*;

class FIFO_scoreboard;
    logic [FIFO_WIDTH-1:0] data_out_ref;
 
    
    bit [FIFO_WIDTH-1:0] fifo_ref[$];

    function void check_data(FIFO_transaction F_txn);
        reference_model(F_txn);
        if (data_out_ref !== F_txn.data_out)begin
            error_count++;
            $display("===============  ERROR  ==========================");
            $display("scoreboard_ERROR: output => %0d not equal the ref Out => %0d", F_txn.data_out, data_out_ref);
            $display("When rst_n: %0d, wr_en: %0d, rd_en: %0d, data_in: %0d", F_txn.rst_n, F_txn.wr_en, F_txn.rd_en, F_txn.data_in);
            $display("===================================================");
        end
        else begin
            correct_count++;
            $display("================  Correct   ======================");
            $display("Correct:: output => %0d equal the ref Out => %0d", F_txn.data_out, data_out_ref);
            $display("When rst_n: %0d, wr_en: %0d, rd_en: %0d, data_in: %0d", F_txn.rst_n, F_txn.wr_en, F_txn.rd_en, F_txn.data_in);
            $display("=======================================================");
        end
    endfunction

    function void reference_model(FIFO_transaction F_txn_param);
        if (!F_txn_param.rst_n)begin
            data_out_ref = 0;
            fifo_ref.delete();
        end
        else begin
            if (F_txn_param.wr_en && !F_txn_param.rd_en) begin
                if (!isFull())begin
                    fifo_ref.push_back(F_txn_param.data_in);
                    $display("HERE in pushing 1");
                end
            end
            else if (F_txn_param.rd_en && !F_txn_param.wr_en) begin
                    if (!isEmpty())begin
                        data_out_ref = fifo_ref.pop_front();
                        $display("HERE in popping 1");
                        
                    end
                    else 
                        $display("EMpty");
                end
            else if (F_txn_param.wr_en && F_txn_param.rd_en) begin
                if (!isEmpty() && !isFull()) begin
                    data_out_ref = fifo_ref.pop_front();
                    fifo_ref.push_back(F_txn_param.data_in);
                    $display("HERE in pushing popping");
                end
                else if (isEmpty()) begin
                    fifo_ref.push_back(F_txn_param.data_in);
                    $display("HERE in pushing 2");
                end
                else if (isFull()) begin
                    data_out_ref = fifo_ref.pop_front();
                    $display("HERE in popping 2");
               
                end
            end
        end
    
        `ifdef DEBUG
        $display("------------------INSIDE GOLDEN MODEL--------------");
        $display("When rst_n: %0d, wr_en: %0d, rd_en: %0d, data_in: %0d", F_txn_param.rst_n, F_txn_param.wr_en, F_txn_param.rd_en, F_txn_param.data_in);
        $display("size of queue: %0d", fifo_ref.size());
        $display("(1)%0d \n(2)%0d \n(3)%0d \n(4)%0d \n(5)%0d", fifo_ref[0], fifo_ref[1], fifo_ref[2], fifo_ref[3], fifo_ref[4]);
        $display("(6)%0d \n(7)%0d \n(8)%0d \n(9)%0d \n(10)%0d", fifo_ref[5], fifo_ref[6], fifo_ref[7], fifo_ref[8], fifo_ref[9]);
        $display("(11)%0d \n(12)%0d", fifo_ref[10], fifo_ref[11]);
        $display("---------------------------------------------------");
        `endif
    endfunction

    function bit isFull();
        if (fifo_ref.size() == FIFO_DEPTH)
            return 1;
        return 0;
    endfunction
    
    function bit isEmpty();
        if (fifo_ref.size() == 0)
            return 1;
        return 0;
    endfunction

endclass

endpackage


