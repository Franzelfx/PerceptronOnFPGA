# Open and Compile
project open PerceptronSim.mpf
project compileall

# Add the Signals
vsim work.tlr_storage_tb(bench)

onerror {resume}
quietly WaveActivateNextPane {} 0
quietly WaveActivateNextPane
add wave -noupdate -divider input
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/clk
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/reset
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/mode
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/address
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/data
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/load
add wave -noupdate -divider {output to layer}
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/address_int_layer
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/data_int_layer
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/load_int_layer
add wave -noupdate -divider {output to storage}
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/address_int_storage
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/data_int_storage
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/load_int_storage
add wave -noupdate -divider {ouutput storage to first layer}
add wave -noupdate /tlr_storage_tb/tlr_storage_inst/storage_to_first_layer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14983753 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {21514500 ps}

view wave
wave zoom full
layout toggle wave
layout zoomwindow wave

# Run Simulation
run -all