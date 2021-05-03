proc AddWaves {} {
    ;#Add waves we're interested in to the Wave window
    add wave -position end sim:/ID_tb/clk
	add wave -position end sim:/ID_tb/rs
	add wave -position end sim:/ID_tb/immediateID
	add wave -position end sim:/ID_tb/rt
	add wave -position end sim:/ID_tb/read_data_1
	add wave -position end sim:/ID_tb/read_data_2
	add wave -position insertpoint sim:/id_tb/RinstID
	add wave -position insertpoint sim:/id_tb/JinstID
	add wave -position insertpoint sim:/id_tb/IinstID
	add wave -position insertpoint /id_tb/registers_inst/rs
	add wave -position insertpoint /id_tb/registers_inst/rt
	add wave -position end sim:/id_tb/write_data_rd
    add wave -position end sim:/id_tb/address_out
	add wave -position insertpoint sim:/id_tb/execute_inst/read_data_rs
	add wave -position insertpoint sim:/id_tb/execute_inst/read_data_rt
	add wave -position insertpoint sim:/id_tb/execute_inst/address_out
	add wave -position insertpoint sim:/id_tb/execute_inst/funct
	add wave -position insertpoint sim:/id_tb/address_out
	add wave -position insertpoint sim:/id_tb/instructionID
}

vlib work

;# Compile components if any
vcom instruction_memory.vhd
vcom IF_adder.vhd
vcom IF_mux.vhd
vcom PC.vhd
vcom fetch.vhd
vcom registers.vhd
vcom decode.vhd
vcom execute.vhd

vcom ID_tb.vhd



;# Start simulation
vsim ID_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 5000 ns
run 10 ns