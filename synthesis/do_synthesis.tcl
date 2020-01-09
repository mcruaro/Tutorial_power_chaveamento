#Chamar esse script assim: genus -files do_synthesis.tcl


#===============================================================================
## load synthesis configuration, read description and elaborate design 
#===============================================================================

set_db script_search_path ./ 
set_db hdl_search_path ../rtl 
set_db information_level 9 

#===============================================================================
#  Load libraries and cap table
#===============================================================================
include libraries/65.tcl

# Compila os scripts
read_hdl -vhdl busca_padrao.vhd

#Elabora o projeto
elaborate busca_padrao

#Define as contraints
read_sdc constraints.sdc

#Faz a sinthese
synthesize -to_generic -eff high
synthesize -to_mapped -eff high -no_incr
write_design -innovus -base_name layout/busca_padrao

#Report power sem chavemento
report power > ../power_no_delay.txt

#Fecha o geanus
exit
