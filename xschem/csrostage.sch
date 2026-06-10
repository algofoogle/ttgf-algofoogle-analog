v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {NOTE:
Plim much stronger than Nlim} 240 -410 0 0 0.2 0.2 {}
N 200 -240 200 -200 {lab=Y}
N 200 -220 350 -220 {lab=Y}
N 160 -270 160 -170 {lab=A}
N 200 -140 200 -110 {lab=#net1}
N 200 -330 200 -300 {lab=#net2}
N 100 -220 160 -220 {lab=A}
N 200 -420 200 -390 {lab=VCC}
N 200 -50 200 -20 {lab=VSS}
N 100 -360 160 -360 {lab=VbiasP}
N 100 -80 160 -80 {lab=VbiasN}
C {symbols/nfet_03v3.sym} 180 -170 0 0 {name=MNi
W=0.80u
L=0.40u
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
C {symbols/pfet_03v3.sym} 180 -270 0 0 {name=MPi
W=1.60u
L=0.40u
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
C {iopin.sym} 70 -460 0 1 {name=p1 lab=VCC}
C {iopin.sym} 70 -440 0 1 {name=p4 lab=VSS}
C {ipin.sym} 100 -220 0 0 {name=p5 lab=A}
C {opin.sym} 350 -220 0 0 {name=p6 lab=Y}
C {lab_pin.sym} 200 -360 0 1 {name=p7 sig_type=std_logic lab=VCC text_size_0=0.2}
C {lab_pin.sym} 200 -170 0 1 {name=p3 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {symbols/pfet_03v3.sym} 180 -360 0 0 {name=MPL
W=3.00u
L=0.30u
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
C {ipin.sym} 100 -360 0 0 {name=p9 lab=VbiasP}
C {lab_pin.sym} 200 -270 0 1 {name=p2 sig_type=std_logic lab=VCC text_size_0=0.2}
C {lab_pin.sym} 200 -420 0 1 {name=p8 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 200 -20 0 1 {name=p10 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 180 -80 0 0 {name=MNL
W=0.60u
L=0.30u
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
C {lab_pin.sym} 200 -80 0 1 {name=p11 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {ipin.sym} 100 -80 0 0 {name=p12 lab=VbiasN}
