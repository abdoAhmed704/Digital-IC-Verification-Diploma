vlib work
vlog DSP.v  DSP_tb.sv +cover -covercells
vsim -voptargs=+acc work.DSP_tb -cover
add wave *
coverage save DSP_tb.ucdb -onexit -du work.ALU_4_bit
run -all
quit -sim