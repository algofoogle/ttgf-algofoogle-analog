v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 40 -710 840 -310 {flags=graph
y1=0
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=2e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="a
y"
color="4 5"
dataset=-1
unitx=1
logx=0
logy=0
}
N 210 -110 260 -110 {lab=Y}
N 260 -180 260 -110 {lab=Y}
C {inverter.sym} 140 -110 0 0 {name=x1}
C {vsource.sym} 40 -250 0 0 {name=V1 value=3.3 savecurrent=false}
C {lab_pin.sym} 40 -280 2 0 {name=p2 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 40 -220 0 1 {name=p4 sig_type=std_logic lab=GND}
C {lab_pin.sym} 160 -140 2 0 {name=p1 sig_type=std_logic lab=VCC}
C {res.sym} 260 -80 0 0 {name=R1
value=10Meg
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 260 -50 0 0 {name=p8 sig_type=std_logic lab=GND}
C {lab_pin.sym} 260 -180 0 0 {name=p9 sig_type=std_logic lab=Y}
C {lab_pin.sym} 160 -80 0 1 {name=p3 sig_type=std_logic lab=GND}
C {vsource.sym} 120 -250 0 0 {name=V2 value="PULSE(0V 3.3V 1ns 5ns 5ns 10ns 30ns)" savecurrent=false}
C {lab_pin.sym} 120 -280 2 0 {name=p5 sig_type=std_logic lab=A}
C {lab_pin.sym} 120 -220 0 1 {name=p6 sig_type=std_logic lab=GND}
C {lab_pin.sym} 120 -110 2 1 {name=p7 sig_type=std_logic lab=A}
C {devices/code_shown.sym} 360 -230 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 360 -130 0 0 {name=NGSPICE only_toplevel=true
value=".control
tran 1p 200ns
write tb_inverter.raw
.endc"}
C {launcher.sym} 710 -290 0 0 {name=h5
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/tb_inverter.raw tran"
}
