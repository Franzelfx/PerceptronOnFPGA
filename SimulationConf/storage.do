# Open and Compile
project open PerceptronSim.mpf
project compileall

# Add the Signals
vsim work.storage_tb(bench)

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /storage_tb/clk
add wave -noupdate /storage_tb/reset
add wave -noupdate /storage_tb/clk_period
add wave -noupdate -divider input
add wave -noupdate /storage_tb/address_in_storage
add wave -noupdate /storage_tb/data_in_storage
add wave -noupdate /storage_tb/load_in_storage
add wave -noupdate -divider output
add wave -noupdate /storage_tb/layer_output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {21743 ps} 0}
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
WaveRestoreZoom {0 ps} {68250 ps}

view wave
wave zoom full
layout toggle wave
layout zoomwindow wave

# Run Simulation
run -all