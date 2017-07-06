#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y gcc
apt-get install -y make
apt-get install -qqy linux-headers-`uname -r`
apt-get upgrade -y
wget -q http://us.download.nvidia.com/XFree86/Linux-x86_64/381.09/NVIDIA-Linux-x86_64-381.09.run -O NVIDIA-Linux-x86_64-381.09.run

chmod +x NVIDIA-Linux-x86_64-381.09.run

# unbind the vtconsole from the nouveau module
sh -c 'echo 0 > /sys/class/vtconsole/vtcon1/bind'

# unload nouveau and the direct rendering modules
rmmod nouveau
rmmod ttm
rmmod drm_kms_helper
rmmod drm

./NVIDIA-Linux-x86_64-381.09.run -a -s
#nvidia-smi

# load the nvidia and direct rendering modules
modprobe nvidia
modprobe ttm
modprobe drm_kms_helper
modprobe drm

# tell linux to rescan the pci bus. The cards will be added using the nvidia modules
sh -c 'echo 1 > /sys/bus/pci/rescan'

wget --no-check-certificate https://gist.githubusercontent.com/brianmingus/5497756754bfbcdaac34d39c2b0f0d71/raw/98e84806716d34bf514d73dbc957b35a709d9f73/nvidia_dev.bash -O /etc/init.d/nvidia
chmod +x /etc/init.d/nvidia
update-rc.d nvidia defaults
service nvidia start

rm -f /var/lib/mesos/slave/meta/slaves/latest && systemctl restart dcos-mesos-slave
#curl -X DELETE leader.mesos/marathon/v2/apps/nvidia-job