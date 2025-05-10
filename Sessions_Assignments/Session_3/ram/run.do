vlib work
vlog ram.sv ram_tb.sv
vsim -voptargs=+acc work.my_mem_tb
add wave *
run -all
