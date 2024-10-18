transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/YITAN/OneDrive/Escritorio/ProyectoGrupalFAC/RBolanos-compu-archi-found-2G1-2024/FAC_SystemVerilog {C:/Users/YITAN/OneDrive/Escritorio/ProyectoGrupalFAC/RBolanos-compu-archi-found-2G1-2024/FAC_SystemVerilog/uart_rx.sv}
vlog -sv -work work +incdir+C:/Users/YITAN/OneDrive/Escritorio/ProyectoGrupalFAC/RBolanos-compu-archi-found-2G1-2024/FAC_SystemVerilog {C:/Users/YITAN/OneDrive/Escritorio/ProyectoGrupalFAC/RBolanos-compu-archi-found-2G1-2024/FAC_SystemVerilog/fpga_top.sv}

vlog -sv -work work +incdir+C:/Users/YITAN/OneDrive/Escritorio/ProyectoGrupalFAC/RBolanos-compu-archi-found-2G1-2024/FAC_SystemVerilog {C:/Users/YITAN/OneDrive/Escritorio/ProyectoGrupalFAC/RBolanos-compu-archi-found-2G1-2024/FAC_SystemVerilog/tb_fpga_top.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_fpga_top

add wave *
view structure
view signals
run -all
