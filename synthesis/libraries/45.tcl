set DK_PATH  "/soft64/design-kits/ncsu/freepdk45/nangate/NangateOpenCellLibrary_PDKv1_3_v2010_12" 

set_db library "${DK_PATH}/Front_End/Liberty/NLDM/NangateOpenCellLibrary_typical.lib"
                       
# set_attribute lef_library "${DK_PATH}/Back_End/lef/NangateOpenCellLibrary.tech.lef"

set_db lef_library "${DK_PATH}/Back_End/lef/NangateOpenCellLibrary.tech.lef \
						${DK_PATH}/Back_End/lef/NangateOpenCellLibrary.lef \
						${DK_PATH}/Back_End/lef/NangateOpenCellLibrary.macro.lef"

##Set captable
set_db cap_table_file /soft64/design-kits/ncsu/freepdk45/nangate//captables/NCSU_FreePDK_45nm.capTbl
