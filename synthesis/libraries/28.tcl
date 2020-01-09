set DK_PATH		"/soft64/design-kits/stm/28nm-cmos28fdsoi_25d"

set_db library "\
	${DK_PATH}/C28SOI_SC_12_CORE_LR@2.0@20130411.0/libs/C28SOI_SC_12_CORE_LR_tt28_1.00V_25C.lib \
	${DK_PATH}/C28SOI_SC_12_CLK_LR@2.1@20130621.0/libs/C28SOI_SC_12_CLK_LR_tt28_1.00V_25C.lib \
	${DK_PATH}/C28SOI_SC_12_PR_LR@2.0@20130412.0/libs/C28SOI_SC_12_PR_LR_tt28_1.00V_25C.lib"

set_db lef_library "\
	${DK_PATH}/C28SOI_SC_12_CORE_LR@2.0@20130411.0/CADENCE/LEF/C28SOI_SC_12_CORE_LR_soc.lef \
	${DK_PATH}/C28SOI_SC_12_CLK_LR@2.1@20130621.0/CADENCE/LEF/C28SOI_SC_12_CLK_LR_soc.lef \
	${DK_PATH}/C28SOI_SC_12_PR_LR@2.0@20130412.0/CADENCE/LEF/C28SOI_SC_12_PR_LR_soc.lef \
	${DK_PATH}/CadenceTechnoKit_cmos028FDSOI_6U1x_2U2x_2T8x_LB_LowPower@1.0.1@20121114.0/LEF/technology.12T.lef"

#Capacitor Lookup table
set_db cap_table_file "/soft64/design-kits/stm/28nm-cmos28lp_42/CadenceTechnoKit_cmos028_6U1x_2U2x_2T8x_LB@4.2.1/CAP_TABLE/nominal.captable"
# qual e o arquivo de cap_table para 28nm? O LEF contem esta informacao?