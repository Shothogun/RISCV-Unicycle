transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/Quartus/ProjetoFinal/Final_Project/memData.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/Final_Project/memIntr.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/PC/PC.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/MUX/MUX-2-1.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/control/Control.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/Adder/Adder.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/xregs/reg_pkg.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/ula/rv_pkg.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/genImm32/genImm32.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/ULA_control/ULA_Control.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/xregs/xregs.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/ula/ula.vhd}
vcom -93 -work work {D:/Quartus/ProjetoFinal/Final_Project/processor.vhd}

vcom -93 -work work {D:/Quartus/ProjetoFinal/Final_Project/processor_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv_hssi -L cycloneiv_pcie_hip -L cycloneiv -L rtl_work -L work -voptargs="+acc"  processor_tb

add wave *
view structure
view signals
run 3 sec
