proc AddWaves {} {
    ;#Add waves we're interested in to the Wave window
	add wave -position end sim:/forwarding_tb/clk
	add wave -position end sim:/forwarding_tb/ID_EX_rs
	add wave -position end sim:/forwarding_tb/ID_EX_rt
	add wave -position end sim:/forwarding_tb/EX_MEM_rd
	add wave -position end sim:/forwarding_tb/MEM_WB_rd
	add wave -position end sim:/forwarding_tb/EX_MEM_RegWrite
	add wave -position end sim:/forwarding_tb/ALU_InputA
	add wave -position end sim:/forwarding_tb/ALU_InputB

}

vlib work

;# Compile components if any
vcom forwarding.vhd
vcom forwarding_tb.vhd

;# Start simulation
vsim forwarding_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 5000 ns
run 10 ns
