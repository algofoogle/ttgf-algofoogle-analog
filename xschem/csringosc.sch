v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 280 -110 840 -110 {lab=vbiasn}
N 380 -100 860 -100 {lab=VSS}
N 380 -260 860 -260 {lab=VCC}
N 880 -180 890 -180 {lab=osc_out}
N 890 -180 890 -80 {lab=osc_out}
N 320 -80 890 -80 {lab=osc_out}
N 320 -180 320 -80 {lab=osc_out}
N 320 -180 340 -180 {lab=osc_out}
N 890 -180 900 -180 {lab=osc_out}
N 620 -100 620 -60 {lab=VSS}
N 620 -290 620 -260 {lab=VCC}
N 240 -140 280 -140 {lab=vbiasn}
N 280 -140 280 -110 {lab=vbiasn}
N 240 -80 240 -60 {lab=VSS}
N 240 -220 240 -140 {lab=vbiasn}
N 240 -360 240 -340 {lab=VCC}
N 360 -250 840 -250 {lab=vbiasp}
N 240 -280 240 -220 {lab=vbiasn}
N 200 -250 360 -250 {lab=vbiasp}
N 200 -310 200 -250 {lab=vbiasp}
N 140 -310 200 -310 {lab=vbiasp}
N 140 -310 140 -280 {lab=vbiasp}
N 100 -280 140 -280 {lab=vbiasp}
N 100 -360 100 -340 {lab=VCC}
N 100 -280 100 -220 {lab=vbiasp}
N 100 -100 100 -80 {lab=VSS}
N 840 -250 900 -250 {lab=vbiasp}
N 840 -110 900 -110 {lab=vbiasn}
C {csrostage.sym} 370 -180 0 0 {name=x1}
C {csrostage.sym} 430 -180 0 0 {name=x2}
C {csrostage.sym} 490 -180 0 0 {name=x3}
C {csrostage.sym} 550 -180 0 0 {name=x4}
C {csrostage.sym} 610 -180 0 0 {name=x5}
C {csrostage.sym} 670 -180 0 0 {name=x6}
C {csrostage.sym} 730 -180 0 0 {name=x7}
C {csrostage.sym} 790 -180 0 0 {name=x8}
C {csrostage.sym} 850 -180 0 0 {name=x9}
C {opin.sym} 900 -180 0 0 {name=p1 lab=osc_out}
C {lab_pin.sym} 620 -60 0 0 {name=p2 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 620 -290 0 0 {name=p3 sig_type=std_logic lab=VCC}
C {symbols/nfet_03v3.sym} 260 -110 0 1 {name=M1
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
C {symbols/pfet_03v3.sym} 220 -310 0 0 {name=M2
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
C {lab_pin.sym} 240 -60 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 240 -110 0 0 {name=p11 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {lab_pin.sym} 240 -310 0 1 {name=p5 sig_type=std_logic lab=VCC text_size_0=0.2
}
C {lab_pin.sym} 240 -360 0 1 {name=p6 sig_type=std_logic lab=VCC}
C {ipin.sym} 60 -190 0 0 {name=p7 lab=vin}
C {iopin.sym} 70 -410 0 1 {name=p8 lab=VCC}
C {iopin.sym} 70 -390 0 1 {name=p9 lab=VSS}
C {symbols/pfet_03v3.sym} 120 -310 0 1 {name=M3
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
C {lab_pin.sym} 100 -310 0 0 {name=p10 sig_type=std_logic lab=VCC text_size_0=0.2
}
C {lab_pin.sym} 100 -360 0 0 {name=p12 sig_type=std_logic lab=VCC}
C {symbols/nfet_03v3.sym} 80 -190 0 0 {name=M4
L=0.50u
W=2.50u
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
C {symbols/ppolyf_u_3k.sym} 100 -130 0 0 {name=R1
W=1e-6
L=1e-6
model=ppolyf_u_3k
spiceprefix=X
m=1}
C {lab_pin.sym} 100 -190 0 1 {name=p13 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {lab_pin.sym} 80 -130 0 0 {name=p14 sig_type=std_logic lab=VSS text_size_0=0.2
}
C {lab_pin.sym} 100 -80 0 0 {name=p15 sig_type=std_logic lab=VSS}
C {opin.sym} 900 -250 0 0 {name=p16 lab=vbiasp}
C {opin.sym} 900 -110 0 0 {name=p17 lab=vbiasn}
