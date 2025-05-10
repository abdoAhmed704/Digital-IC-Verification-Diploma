vlib work
vlog pkd.sv alu_tb.sv alu.sv  +cover -covercells
vsim -voptargs=+acc work.alu_tb -cover
add wave *
coverage save alu_CC.ucdb  -onexit -du work.alu_seq
run -all 

quit -sim

vcover report alu_CC.ucdb  -details -annotate -all
