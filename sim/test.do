-- project     : axi_regs_tb
-- date        : 22.01.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axi_regs

vlib work
vmap work work

vlog ../tb/axi_regs_tb.sv
vlog ../src/axi_regs.sv

vsim -t 1ps -voptargs=+acc=lprn -lib work axi_regs_tb

do wave_test.do 
view wave
run 6 us