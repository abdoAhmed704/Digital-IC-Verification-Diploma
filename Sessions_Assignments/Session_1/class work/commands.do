vlib work
vlog lab_1.v  lab_1_tb.sv +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit -du adder -output coverage.txt
run -all