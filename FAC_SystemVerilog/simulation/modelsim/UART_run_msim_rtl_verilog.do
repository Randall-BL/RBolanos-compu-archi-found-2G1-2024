transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_tarea {C:/Users/tenor/OneDrive/Documentos/FAC_tarea/uart_rx.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_tarea {C:/Users/tenor/OneDrive/Documentos/FAC_tarea/fpga_top.sv}
vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_tarea/output_files {C:/Users/tenor/OneDrive/Documentos/FAC_tarea/output_files/uart_tx.sv}

vlog -sv -work work +incdir+C:/Users/tenor/OneDrive/Documentos/FAC_tarea {C:/Users/tenor/OneDrive/Documentos/FAC_tarea/tb_fpga_top.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_fpga_top

add wave *
view structure
view signals
run -all