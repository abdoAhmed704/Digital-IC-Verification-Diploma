vlib work

vlog -f src_files_fixed.list  +define+SIM  +cover 
# ADD THIS IF YOU WANT TO SEE EVERYTHING:=> <+define+DEBUG>

vsim -voptargs=+acc work.FIFO_top -cover
add wave *
add wave  /FIFO_top/dut/rd_ptr /FIFO_top/dut/wr_ptr /FIFO_top/dut/count /FIFO_top/dut/write_acknowledge_assert /FIFO_top/dut/overflow_assert /FIFO_top/dut/underflow_assert /FIFO_top/dut/empty_assert /FIFO_top/dut/full_assert /FIFO_top/dut/almsotfull_assert  /FIFO_top/dut/rd_ptr_wrap_asset   /FIFO_top/dut/almsotempty_assert
coverage save FIFO_cov.ucdb -onexit -du work.FIFO
run -all








