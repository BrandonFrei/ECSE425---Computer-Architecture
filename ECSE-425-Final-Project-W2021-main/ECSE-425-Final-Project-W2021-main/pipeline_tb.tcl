proc AddWaves {} {
    ;#Add waves we're interested in to the Wave window
	add wave -position end sim:/pipeline_tb/clk
}

vlib work

;# Compile components if any
vcom instruction_memory.vhd
vcom IF_adder.vhd
vcom IF_mux.vhd
vcom fetch.vhd
vcom pipeline.vhd
vcom pipeline_tb.vhd

;# Start simulation
vsim pipeline_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 5000 ns
run 1000 ns