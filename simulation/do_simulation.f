#Run this command with xrun -f do_simulation.f
-smartorder -work work -V93 -top user_logic_tb -access +rw -maxdelays -sdf_cmd_file sdf_cmd.cmd -sdf_verbose -input control_vcd.tcl
	/soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/behaviour/verilog/CORE65GPSVT.v
	/soft64/design-kits/stm/65nm-cmos065_536/CLOCK65GPSVT_3.1/behaviour/verilog/CLOCK65GPSVT.v
	../synthesis/layout/busca_padrao.v
	../test_bench/tb_padrao.vhd
