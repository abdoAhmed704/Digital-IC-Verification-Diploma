vlib work
vlog -f src_files.list +define+DEBUG
#  +define+DEBUG
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/fifo_interface_ins/*
add wave /uvm_pkg::uvm_reg_map::do_write/#ublk#215181159#1731/immed__1735 /uvm_pkg::uvm_reg_map::do_read/#ublk#215181159#1771/immed__1775 /fifo_write_read_seq_pkg::fifo_write_read_seq::body/#ublk#164226423#16/immed__18 /fifo_read_seq_pkg::fifo_read_seq::body/#ublk#253944871#16/immed__18 /fifo_write_seq_pkg::fifo_write_seq::body/#ublk#26928919#16/immed__18 /top/dut/sva_f/Reset_Behavior /top/dut/sva_f/empty_assert /top/dut/sva_f/rd_ptr_wrap_asset /top/dut/sva_f/write_acknowledge_assert /top/dut/sva_f/overflow_assert /top/dut/sva_f/underflow_assert /top/dut/sva_f/full_assert /top/dut/sva_f/almsotfull_assert /top/dut/sva_f/almsotempty_assert
coverage save FIFO_cov.ucdb -onexit -du work.FIFO
run -all
