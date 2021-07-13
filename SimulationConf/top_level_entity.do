# Open and Compile
project open PerceptronSim.mpf
project compileall

# Add the Signals
vsim work.top_level_entity_tb(bench)

onerror {resume}
quietly WaveActivateNextPane {} 0
quietly WaveActivateNextPane
add wave -noupdate -divider Input
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/clk
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/reset
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/mode
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/address
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/data
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/load
add wave -noupdate -divider {Top Level Resolver}
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/address_int_layer
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/data_int_layer
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/load_int_layer
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/address_int_storage
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/data_int_storage
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/load_int_storage
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/storage_to_first_layer
add wave -noupdate -divider {Perceptron Layers}
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_axon_arr
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/address_layer_arr
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/data_layer_arr
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/load_layer
add wave -noupdate -divider Output
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/result
add wave -noupdate -divider {Perceptron Signals}
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_1(0)/layer_1_inst/activation_value
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_1(0)/layer_1_inst/sensitivity_value
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_1(0)/layer_1_inst/sens_1
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_1(0)/layer_1_inst/sens_2
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_1(0)/layer_1_inst/sens_3
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_1(0)/layer_1_inst/sens_4
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_1(0)/layer_1_inst/axon_port
add wave -noupdate /top_level_entity_tb/top_level_entity_inst/layer_1(0)/layer_1_inst/dentrid_port
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19449546 ps} 0}
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
WaveRestoreZoom {0 ps} {43018752 ps}

view wave
wave zoom full
layout toggle wave
layout zoomwindow wave

# Run Simulation
run -all