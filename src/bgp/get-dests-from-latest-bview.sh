#!/bin/sh
if [ -z "$1" ]; then
	echo "Usage: $0 FILE"
	echo "FILE    latest-bview.gz"
	exit 1
fi

####
# Note that the first destination entry is default route 0.0.0.0/0
# and the latest-bview.gz file also contains subnets such as 10.0.0.0/8 or 192.168.0.0/16,
# which you may want to remove from the output
####
/usr/local/bin/bgpdump "$1" | grep 'PREFIX' | grep '\.' | sed 's/PREFIX: \(.*\)/\1/' | uniq
