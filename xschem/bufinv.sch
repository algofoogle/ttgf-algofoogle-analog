v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 150 -190 150 -150 {lab=Y}
N 150 -170 250 -170 {lab=Y}
N 110 -220 110 -120 {lab=A}
N 150 -90 150 -60 {lab=VSS}
N 150 -280 150 -250 {lab=VCC}
N 50 -170 110 -170 {lab=A}
C {symbols/nfet_03v3.sym} 130 -120 0 0 {name=MNi
W=1u
L=0.28u
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
C {symbols/pfet_03v3.sym} 130 -220 0 0 {name=MPi
W=2u
L=0.28u
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
C {iopin.sym} 80 -300 0 1 {name=p1 lab=VCC}
C {iopin.sym} 80 -280 0 1 {name=p4 lab=VSS}
C {ipin.sym} 50 -170 0 0 {name=p5 lab=A}
C {opin.sym} 250 -170 0 0 {name=p6 lab=Y}
C {lab_pin.sym} 150 -120 0 1 {name=p3 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {lab_pin.sym} 150 -220 0 1 {name=p2 sig_type=std_logic lab=VCC text_size_0=0.2}
C {lab_pin.sym} 150 -280 0 1 {name=p7 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 150 -60 0 1 {name=p8 sig_type=std_logic lab=VSS}
