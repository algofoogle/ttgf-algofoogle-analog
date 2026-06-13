v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 30 -930 830 -530 {flags=graph,unlocked
y1=-0.013
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1.2143475e-05
x2=1.2734914e-05
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="osc
vbiasp
vbiasn
vin
osc_raw"
color="4 5 12 15 18"
dataset=-1
unitx=1
logx=0
logy=0
hcursor1_y=0.6}
B 2 860 -930 1660 -530 {flags=graph,unlocked
y1=-0.14
y2=3.5
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=5.0546045e-05
x2=5.0549563e-05
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="osc
vbiasp
vbiasn
vin
osc_raw"
color="4 5 12 15 18"
dataset=-1
unitx=1
logx=0
logy=0
hcursor1_y=1.00}
C {csringosc.sym} 160 -270 0 0 {name=x1}
C {vsource.sym} 70 -440 0 0 {name=V1 value=3.3 savecurrent=false}
C {lab_pin.sym} 270 -280 0 1 {name=p9 sig_type=std_logic lab=osc}
C {vsource.sym} 150 -440 0 0 {name=V2 value="PWL(0us 0.0v   0.1us 0.0v  2us 0.55v  10us 0.55v  15us 0.65v  50us 3.3v  51us 3.3v)" savecurrent=false}
C {devices/code_shown.sym} 760 -410 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
* .lib $::180MCU_MODELS/sm141064.ngspice res_statistical
"}
C {devices/code_shown.sym} 350 -310 0 0 {name=NGSPICE only_toplevel=true
value=".control
save i(vcc) i(vin) vin vbiasp vbiasn osc osc_raw
tran 10p 51us
write tb_csringosc.raw
.endc"}
C {launcher.sym} 700 -510 0 0 {name=h5
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/tb_csringosc.raw tran"
}
C {lab_pin.sym} 70 -410 0 0 {name=p1 sig_type=std_logic lab=GND}
C {lab_pin.sym} 150 -410 0 0 {name=p2 sig_type=std_logic lab=GND}
C {lab_pin.sym} 270 -300 0 1 {name=p3 sig_type=std_logic lab=vbiasp}
C {lab_pin.sym} 270 -240 0 1 {name=p4 sig_type=std_logic lab=vbiasn}
C {lab_pin.sym} 160 -200 0 0 {name=p5 sig_type=std_logic lab=GND}
C {lab_pin.sym} 70 -470 0 0 {name=p6 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 150 -470 0 0 {name=p7 sig_type=std_logic lab=VIN}
C {lab_pin.sym} 50 -270 0 0 {name=p8 sig_type=std_logic lab=VIN}
C {lab_pin.sym} 160 -340 0 0 {name=p10 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 270 -260 0 1 {name=p11 sig_type=std_logic lab=osc_raw}
C {launcher.sym} 920 -510 0 0 {name=h1
descr="load old waves" 
tclcommand="xschem raw_read $netlist_dir/tb_csringosc-ppolyfu1k5X2-XMNcNF6.raw tran"
}
