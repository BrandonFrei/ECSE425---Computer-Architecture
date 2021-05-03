proc AddWaves {} {
    ;#Add waves we're interested in to the Wave window
	add wave -position end  sim:/fetch_tb/clk
	add wave -position end  sim:/fetch_tb/PC_output
	add wave -position end  sim:/fetch_tb/instruction
	add wave -position end  sim:/fetch_tb/address
	add wave -position end  sim:/fetch_tb/adder_signal
	add wave -position end  sim:/fetch_tb/IF_mux_output
	add wave -position end  sim:/fetch_tb/mux_selector
	add wave -position end  sim:/fetch_tb/mux_output_test
}

vlib work

;# Compile components if any
vcom instruction_memory.vhd
vcom IF_adder.vhd
vcom IF_mux.vhd
vcom PC.vhd
vcom fetch.vhd

vcom fetch_tb.vhd



;# Start simulation
vsim fetch_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 5000 ns
run 10 ns