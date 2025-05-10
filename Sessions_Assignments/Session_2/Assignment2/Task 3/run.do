vlib work
vlog pkg.sv ALSU.v   ALUS_tb.sv   +cover -covercells
vsim -voptargs=+acc work.ALSU_tb  -cover
add wave *
coverage save Alus.ucdb -onexit -du work.ALSU
run -all
