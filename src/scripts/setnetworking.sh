#!/bin/bash

cd $(dirname $(readlink -f $0))

if [ $# -eq 2 ]; then
	ENP="$1"
	ENPD1="$2"
elif [ $# -eq 0 ]; then
	source getintfnames.sh
else
	echo "USAGE:"
	echo "$0"
	echo "$0" "intf_1" "intf_2"
fi

echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

ip neigh add 192.0.2.2 lladdr 00:10:94:00:00:01 dev "$ENPD1"
ip neigh add 192.0.2.6 lladdr 00:10:94:00:00:02 dev "$ENP"

ip -6 neigh add 2001:db8:1::2 lladdr 00:10:94:00:00:03 dev "$ENPD1"
ip -6 neigh add 2001:db8:2::6 lladdr 00:10:94:00:00:04 dev "$ENP"

ip addr add 192.0.2.1/30 broadcast 192.0.2.3 dev "$ENPD1"
ip addr add 192.0.2.5/30 broadcast 192.0.2.7 dev "$ENP"

ip -6 addr add 2001:db8:1::1/64 dev "$ENPD1"
ip -6 addr add 2001:db8:2::5/64 dev "$ENP"
