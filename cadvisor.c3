# from docker://google/cadvisor

c3-ctl add docker://google/cadvisor

c3-cfg -n cadvisor mount bind:/:/rootfs
c3-cfg -n cadvisor mount bind:/proc:/rootfs/proc
c3-cfg -n cadvisor mount bind:/var/run:/var/run
c3-cfg -n cadvisor mount bind:/dev/disk/:/dev/disk/
c3-cfg -n cadvisor mount bind:/sys:/sys
c3-cfg -n cadvisor mount bind:/sys/fs/cgroup:/sys/fs/cgroup
c3-cfg -n cadvisor mount bind:/sys/fs/cgroup/cpu:/sys/fs/cgroup/cpu
c3-cfg -n cadvisor mount bind:/sys/fs/cgroup/devices:/sys/fs/cgroup/devices
c3-cfg -n cadvisor mount bind:/sys/fs/cgroup/cpuacct:/sys/fs/cgroup/cpuacct
c3-cfg -n cadvisor mount bind:/sys/fs/cgroup/cpuset:/sys/fs/cgroup/cpuset
c3-cfg -n cadvisor mount bind:/sys/fs/cgroup/memory:/sys/fs/cgroup/memory
c3-cfg -n cadvisor mount bind:/sys/fs/cgroup/blkio:/sys/fs/cgroup/blkio

c3-ctl start cadvisor

netprime=$(c3-ctl netprime)
c3-cfg link $netprime:8080 cadvisor:8080

c3-cfg gen $netprime
c3-cfg gen cadvisor

c3-ctl stack $netprime
c3-ctl stack cadvisor
