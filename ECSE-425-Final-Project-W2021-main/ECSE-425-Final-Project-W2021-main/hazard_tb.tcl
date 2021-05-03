proc AddWaves {} {
    ;#Add waves we're interested in to the Wave window
	add wave -position end sim:/hazard_tb/clk
	add wave -position end sim:/hazard_tb/IF_ID_rs
	add wave -position end sim:/hazard_tb/IF_ID_rt
	add wave -position end sim:/hazard_tb/ID_EX_rs
	add wave -position end sim:/hazard_tb/ID_EX_rt
	add wave -position end sim:/hazard_tb/ID_EX_MemRead
	add wave -position end sim:/hazard_tb/stall
}

vlib work

;# Compile components if any
vcom hazard.vhd
vcom hazard_tb.vhd

;# Start simulation
vsim hazard_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 5000 ns
run 10 ns
