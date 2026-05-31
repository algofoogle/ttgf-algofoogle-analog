v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 410 -310 410 -270 {lab=Y}
N 410 -290 560 -290 {lab=Y}
N 370 -340 370 -240 {lab=A}
N 410 -210 410 -180 {lab=VSS}
N 410 -400 410 -370 {lab=VCC}
N 410 -340 450 -340 {lab=VCC}
N 410 -240 450 -240 {lab=VSS}
N 300 -290 370 -290 {lab=A}
C {symbols/nfet_03v3.sym} 390 -240 0 0 {name=M1
L=0.50u
W=0.25u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 390 -340 0 0 {name=M2
L=0.50u
W=0.50u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {iopin.sym} 320 -400 0 1 {name=p1 lab=VCC}
C {iopin.sym} 320 -380 0 1 {name=p4 lab=VSS}
C {ipin.sym} 300 -290 0 0 {name=p5 lab=A}
C {opin.sym} 560 -290 0 0 {name=p6 lab=Y}
C {lab_pin.sym} 410 -400 0 1 {name=p7 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 450 -340 0 1 {name=p2 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 450 -240 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 410 -180 0 1 {name=p8 sig_type=std_logic lab=VSS}
