v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 30 -760 830 -360 {flags=graph
y1=-0.2
y2=3.5
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=6.0637707e-08
x2=6.6267179e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=osc
color=4
dataset=-1
unitx=1
logx=0
logy=0
}
C {basicring9.sym} 210 -100 0 0 {name=x1}
C {vsource.sym} 60 -110 0 0 {name=V1 value=3.3V savecurrent=false}
C {lab_pin.sym} 210 -150 2 0 {name=p1 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 60 -140 2 0 {name=p2 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 60 -80 0 1 {name=p4 sig_type=std_logic lab=GND}
C {lab_pin.sym} 210 -50 0 1 {name=p3 sig_type=std_logic lab=GND}
C {lab_pin.sym} 300 -100 2 0 {name=p5 sig_type=std_logic lab=osc}
C {devices/code_shown.sym} 40 -270 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 520 -270 0 0 {name=NGSPICE only_toplevel=true
value=".control
tran 1p 200n uic
write tb_basicring9.raw
.endc"}
C {launcher.sym} 710 -330 0 0 {name=h5
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/tb_basicring9.raw tran"
}
