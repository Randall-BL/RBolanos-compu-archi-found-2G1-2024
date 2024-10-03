transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/Github/Proyecto2FAC/FAC-Decoder {C:/Users/tenor/OneDrive/Documentos/Github/Proyecto2FAC/FAC-Decoder/Decoder_4To2bits.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/Github/Proyecto2FAC/FAC-Decoder {C:/Users/tenor/OneDrive/Documentos/Github/Proyecto2FAC/FAC-Decoder/bcd_to_7seg_2bits.sv}

vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/Github/Proyecto2FAC/FAC-Decoder {C:/Users/tenor/OneDrive/Documentos/Github/Proyecto2FAC/FAC-Decoder/tb_Decoder_4To2bits.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_Decoder_4To2bits

add wave *
view structure
view signals
run -all
