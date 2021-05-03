proc AddWaves {} {
    ;#Add waves we're interested in to the Wave window
    add wave -position end sim:/execute_tb/clk
    add wave -position end sim:/execute_tb/write_data_rd
    add wave -position end sim:/execute_tb/address_out
}

vlib work

;# Compile components if any
vcom execute.vhd
vcom execute_tb.vhd

;# Start simulation
vsim execute_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 5000 ns
run 10 ns
