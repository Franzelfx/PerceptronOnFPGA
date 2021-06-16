# Open and Compile
project open PerceptronSim.mpf
project compileall

# Add the Signals
vsim work.top_level_resolver_tb(bench)

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_level_resolver_tb/reset
add wave -noupdate /top_level_resolver_tb/mode
add wave -noupdate -divider input
add wave -noupdate /top_level_resolver_tb/address_in
add wave -noupdate /top_level_resolver_tb/data_in
add wave -noupdate /top_level_resolver_tb/load_in
add wave -noupdate -divider {output layer}
add wave -noupdate /top_level_resolver_tb/address_out_layer
add wave -noupdate /top_level_resolver_tb/data_out_layer
add wave -noupdate /top_level_resolver_tb/load_out_layer
add wave -noupdate -divider {output storage}
add wave -noupdate /top_level_resolver_tb/address_out_storage
add wave -noupdate /top_level_resolver_tb/data_out_storage
add wave -noupdate /top_level_resolver_tb/load_out_storage

# Set the View
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {31500 ps}

view wave
wave zoom full
layout toggle wave
layout zoomwindow wave

# Run Simulation
run -all
