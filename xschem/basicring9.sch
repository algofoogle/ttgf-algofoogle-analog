v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 890 -160 890 -100 {lab=osc_out}
N 80 -100 890 -100 {lab=osc_out}
N 80 -160 80 -100 {lab=osc_out}
N 120 -130 840 -130 {lab=VSS}
N 120 -130 120 -80 {lab=VSS}
N 120 -190 840 -190 {lab=VCC}
N 120 -230 120 -190 {lab=VCC}
C {inverter.sym} 100 -160 0 0 {name=x1}
C {inverter.sym} 190 -160 0 0 {name=x2}
C {inverter.sym} 280 -160 0 0 {name=x3}
C {inverter.sym} 370 -160 0 0 {name=x4}
C {inverter.sym} 460 -160 0 0 {name=x5}
C {inverter.sym} 550 -160 0 0 {name=x6}
C {inverter.sym} 640 -160 0 0 {name=x7}
C {inverter.sym} 730 -160 0 0 {name=x8}
C {inverter.sym} 820 -160 0 0 {name=x9}
C {opin.sym} 890 -160 0 0 {name=p1 lab=osc_out}
C {iopin.sym} 230 -240 2 0 {name=p2 lab=VCC}
C {iopin.sym} 230 -220 2 0 {name=p3 lab=VSS}
C {lab_pin.sym} 120 -230 0 0 {name=p4 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 120 -80 0 0 {name=p5 sig_type=std_logic lab=VSS}
