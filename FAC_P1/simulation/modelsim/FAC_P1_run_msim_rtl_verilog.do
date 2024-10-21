transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/alu.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/full_adder_2bit.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/unit_adder.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/substractor_2bit.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/ANDoperation_2bit.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/ORoperation_2bit.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/pwm.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/top_module.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/bin_to_7seg.sv}

vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_P1 {C:/Users/tenor/OneDrive/Documentos/FAC_P1/tb_top_module.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_top_module

add wave *
view structure
view signals
run -all
