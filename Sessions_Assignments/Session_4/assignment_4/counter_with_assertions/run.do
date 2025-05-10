vlib work
vlog *v  +cover 
vsim -voptargs=+acc top -cover
add wave *
add wave /top/dut/sva_inst/a_reset /top/dut/sva_inst/Assert_load_p /top/dut/sva_inst/Assert_out_not_changes_p /top/dut/sva_inst/Assert_increment_out_p /top/dut/sva_inst/Assert_decrement_out_p /top/dut/sva_inst/Assert_zero_p /top/dut/sva_inst/Assert_max_count_p /top/c_tb/#ublk#95084642#14/immed__15
coverage save top.ucdb -onexit
run -all 
