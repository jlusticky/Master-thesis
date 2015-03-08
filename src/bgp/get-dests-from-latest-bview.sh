#!/bin/sh
if [ -z "$1" ]; then
	echo "Usage: $0 FILE"
	echo "FILE    latest-bview.gz"
	exit 1
fi

/usr/local/bin/bgpdump "$1" | grep 'PREFIX' | grep '\.' | sed 's/PREFIX: \(.*\)/\1/' | uniq
