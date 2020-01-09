default: clean all

all:
	module purge && \
	module load genus && \
	cd synthesis && \
	genus -files do_synthesis.tcl && \
	cd ../simulation	&& \
	module purge && \
	module load xcelium	 && \
	xrun -f do_simulation.f && \
	cd ../synthesis && \
	module purge && \
	module load genus && \
	genus -files do_power_report.tcl
	@echo 'Project generated with succcess!'

clean:
	@rm -rf synthesis/layout
	@rm -rf synthesis/fv
	@rm -rf simulation/xcelium.d
	@find . -name "*genus*" -delete
	@find . -name "*xcelium*" -delete
	@find . -name "*xrun*" -delete
	@rm -rf simulation/chaveamento.tcf
	@rm -rf power_no_delay.txt
	@rm -rf power_with_delay.txt
	@rm -rf *.log
	@echo 'Project is clean, belive me!'

