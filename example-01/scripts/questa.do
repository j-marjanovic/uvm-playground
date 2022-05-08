
if {[file exists work]} {
    vdel -lib work -all
}

vlog ../hdl/simple_alu.sv

vlog ../test/simple_alu_tb.sv

vsim work.simple_alu_tb

run 100 ns
