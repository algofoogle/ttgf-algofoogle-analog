v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {NOTE XMNc:
6 fingers
=> 5u*6
=> 30u/0.7u} 10 -270 0 0 0.15 0.15 {}
N 670 -180 680 -180 {lab=osc_out}
N 680 -180 680 -80 {lab=osc_out}
N 320 -80 680 -80 {lab=osc_out}
N 320 -180 320 -80 {lab=osc_out}
N 320 -180 340 -180 {lab=osc_out}
N 680 -180 690 -180 {lab=osc_out}
N 620 -100 620 -60 {lab=VSS}
N 620 -290 620 -260 {lab=VCC}
N 240 -140 280 -140 {lab=vbiasn}
N 280 -140 280 -110 {lab=vbiasn}
N 240 -80 240 -60 {lab=VSS}
N 240 -220 240 -140 {lab=vbiasn}
N 240 -360 240 -340 {lab=VCC}
N 240 -280 240 -220 {lab=vbiasn}
N 200 -250 360 -250 {lab=vbiasp}
N 200 -310 200 -250 {lab=vbiasp}
N 140 -310 200 -310 {lab=vbiasp}
N 140 -310 140 -280 {lab=vbiasp}
N 100 -280 140 -280 {lab=vbiasp}
N 100 -360 100 -340 {lab=VCC}
N 100 -280 100 -250 {lab=vbiasp}
N 360 -110 690 -110 {lab=vbiasn}
N 360 -250 690 -250 {lab=vbiasp}
N 280 -110 360 -110 {lab=vbiasn}
N 640 -180 670 -180 {lab=osc_out}
N 380 -260 620 -260 {lab=VCC}
N 380 -100 620 -100 {lab=VSS}
N 100 -70 100 -60 {lab=VSS}
N 720 -150 720 -130 {lab=VSS}
N 720 -230 720 -210 {lab=VCC}
N 820 -150 820 -130 {lab=VSS}
N 820 -230 820 -210 {lab=VCC}
N 770 -180 790 -180 {lab=#net1}
N 870 -180 890 -180 {lab=osc_out}
C {csrostage.sym} 370 -180 0 0 {name=x1}
C {csrostage.sym} 430 -180 0 0 {name=x2}
C {csrostage.sym} 490 -180 0 0 {name=x3}
C {csrostage.sym} 550 -180 0 0 {name=x4}
C {csrostage.sym} 610 -180 0 0 {name=x5}
C {opin.sym} 890 -180 0 0 {name=p1 lab=osc_out}
C {lab_pin.sym} 620 -60 0 0 {name=p2 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 620 -290 0 0 {name=p3 sig_type=std_logic lab=VCC}
C {symbols/nfet_03v3.sym} 260 -110 0 1 {name=MNL
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
C {symbols/pfet_03v3.sym} 220 -310 0 0 {name=MPL
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
C {lab_pin.sym} 240 -60 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 240 -110 0 0 {name=p11 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {lab_pin.sym} 240 -310 0 1 {name=p5 sig_type=std_logic lab=VCC text_size_0=0.2
}
C {lab_pin.sym} 240 -360 0 1 {name=p6 sig_type=std_logic lab=VCC}
C {ipin.sym} 60 -220 0 0 {name=p7 lab=vin}
C {iopin.sym} 70 -410 0 1 {name=p8 lab=VCC}
C {iopin.sym} 70 -390 0 1 {name=p9 lab=VSS}
C {symbols/pfet_03v3.sym} 120 -310 0 1 {name=MPb
W=4.00u
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
C {lab_pin.sym} 100 -310 0 0 {name=p10 sig_type=std_logic lab=VCC text_size_0=0.2
}
C {lab_pin.sym} 100 -360 0 0 {name=p12 sig_type=std_logic lab=VCC}
C {symbols/nfet_03v3.sym} 80 -220 0 0 {name=MNc
W=30.00u
L=0.70u
nf=6
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
C {lab_pin.sym} 100 -220 0 1 {name=p13 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {lab_pin.sym} 120 -160 0 1 {name=p14 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {lab_pin.sym} 100 -60 0 0 {name=p15 sig_type=std_logic lab=VSS}
C {opin.sym} 690 -250 0 0 {name=p16 lab=vbiasp}
C {opin.sym} 690 -110 0 0 {name=p17 lab=vbiasn}
C {symbols/ppolyf_u_1k.sym} 100 -160 0 1 {name=R2
W=1u
L=5u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 120 -100 0 1 {name=p18 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {symbols/ppolyf_u_1k.sym} 100 -100 0 1 {name=R1
W=1u
L=5u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {bufinv.sym} 720 -180 0 0 {name=x6}
C {lab_pin.sym} 720 -230 0 1 {name=p19 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 720 -130 0 1 {name=p20 sig_type=std_logic lab=VSS}
C {bufinv.sym} 820 -180 0 0 {name=x7}
C {lab_pin.sym} 820 -230 0 1 {name=p21 sig_type=std_logic lab=VCC}
C {lab_pin.sym} 820 -130 0 1 {name=p22 sig_type=std_logic lab=VSS}
C {opin.sym} 680 -80 0 0 {name=p23 lab=osc_raw}
