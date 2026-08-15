-- project     : axi_regs
-- version     : 1.0
-- date        : 22.01.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axi_regs

-- Waves
add wave -noupdate -divider testbench
add wave -noupdate -format Logic -radix HEXADECIMAL -group {testbench} /axi_regs_tb/*

add wave -noupdate -divider DUT
add wave -noupdate -format Logic -radix HEXADECIMAL -group {DUT} /axi_regs_tb/DUT_inst/*

-- Toggle leaf names command
config wave -signalnamewidth 1