#!/bin/bash

cd $(dirname $(readlink -f $0))

systemctl stop firewalld

echo performance | tee /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor > /dev/null
echo 0 | tee /proc/sys/net/ipv4/conf/*/rp_filter > /dev/null
