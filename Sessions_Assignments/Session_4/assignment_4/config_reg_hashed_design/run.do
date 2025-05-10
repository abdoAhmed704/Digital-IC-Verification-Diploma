vlog config_reg_buggy_questa.svp config_reg_tb.sv 

vsim -voptargs=+acc work.config_reg_tb
add wave *
run -all