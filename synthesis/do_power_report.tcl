#Carrega o projeto no momennto apos a sintese
source layout/busca_padrao.genus_setup.tcl

#Le o arquivo de chaveamneto
read_tcf ../simulation/chaveamento.tcf

#Le o arquivo de chaveamneto
report power > ../power_with_delay.txt

exit