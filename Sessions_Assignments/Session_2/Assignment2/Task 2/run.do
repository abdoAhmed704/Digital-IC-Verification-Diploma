vlib work
vlog pkg.sv counter_tb.sv  counter.v  +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
add wave *
coverage save counter_u.ucdb -onexit -du work.counter
run -all 