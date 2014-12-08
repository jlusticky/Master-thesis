#!/bin/sh
head -n 1 /proc/interrupts
while true; do
	grep enp0s9 /proc/interrupts
	sleep 1
done
