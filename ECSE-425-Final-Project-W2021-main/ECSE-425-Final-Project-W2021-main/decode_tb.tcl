proc AddWaves {} {
    ;#Add waves we're interested in to the Wave window
    add wave -position end sim:/decode_tb/clk
}

vlib work

;# Compile components if any
vcom decode.vhd
vcom decode_tb.vhd

;# Start simulation
vsim decode_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 5000 ns
run 2 ns