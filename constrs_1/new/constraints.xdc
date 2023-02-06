#Clock signal
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports clock]
create_clock -period 32.000 -name sys_clk_pin -waveform {0.000 16.000} -add [get_ports clock]

set_property IOSTANDARD LVCMOS33 [get_ports {P0[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P1[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P1[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {P1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

#Reset
set_property PACKAGE_PIN Y16 [get_ports reset]

#Leds
set_property PACKAGE_PIN M14 [get_ports {P1[0]}]
set_property PACKAGE_PIN M15 [get_ports {P1[1]}]
set_property PACKAGE_PIN G14 [get_ports {P1[2]}]
set_property PACKAGE_PIN D18 [get_ports {P1[3]}]

#Pmod JC (high-speed)
set_property PACKAGE_PIN V15 [get_ports {P1[4]}]
set_property PACKAGE_PIN W15 [get_ports {P1[5]}]
set_property PACKAGE_PIN T11 [get_ports {P1[6]}]
set_property PACKAGE_PIN T10 [get_ports {P1[7]}]

#external int
set_property PACKAGE_PIN V16 [get_ports {P0[0]}]

#Pmod JB (high-speed)
set_property PACKAGE_PIN T20 [get_ports {P0[1]}]
set_property PACKAGE_PIN U20 [get_ports {P0[2]}]
set_property PACKAGE_PIN V20 [get_ports {P0[3]}]
set_property PACKAGE_PIN W20 [get_ports {P0[4]}]
set_property PACKAGE_PIN Y18 [get_ports {P0[5]}]
set_property PACKAGE_PIN Y19 [get_ports {P0[6]}]
set_property PACKAGE_PIN W18 [get_ports {P0[7]}]



connect_debug_port u_ila_0/probe3 [get_nets [list {state[0]} {state[1]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {ctrl_unit/state[2]} {ctrl_unit/state[3]} {ctrl_unit/state[4]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list int_ext0]]


connect_debug_port u_ila_0/probe6 [get_nets [list {ctrl_unit/state[4]_i_2_n_0}]]

