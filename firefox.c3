c3-ctl add docker://sassmann/debian-firefox

c3-ctl stop cube-desktop

c3-cfg link localhost:.XIM-unix cube-desktop:/tmp/.XIM-unix
c3-cfg link localhost:.Test-unix cube-desktop:/tmp/.Test-unix
c3-cfg link localhost:.ICE-unix cube-desktop:/tmp/.ICE-unix
c3-cfg link localhost:.font-unix cube-desktop:/tmp/.font-unix
c3-cfg link localhost:.X11-unix cube-desktop:/tmp/.X11-unix

c3-cfg link localhost:.XIM-unix debian-firefox:/tmp/.XIM-unix
c3-cfg link localhost:.Test-unix debian-firefox:/tmp/.Test-unix
c3-cfg link localhost:.ICE-unix debian-firefox:/tmp/.ICE-unix
c3-cfg link localhost:.font-unix debian-firefox:/tmp/.font-unix
c3-cfg link localhost:.X11-unix debian-firefox:/tmp/.X11-unix
c3-cfg -n debian-firefox set cube.env:DISPLAY=:0
c3-cfg -n debian-firefox set cube.env:XAUTHORITY=/root/.Xauthority

c3-cfg gen cube-desktop
c3-cfg gen debian-firefox

c3-ctl start cube-desktop

# to complete the runtime, do the following steps:

## <log into X session as appropriate>

# c3-cfg auth X:cube-desktop:debian-firefox
# c3 start debian-firefox

