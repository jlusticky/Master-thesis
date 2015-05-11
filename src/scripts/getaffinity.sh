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

# get RX-TX irqs
for DEV in "$ENP" "$ENPD1"; do
	I=0
	for IRQNUM in `grep -w "$DEV" /proc/interrupts | awk {'print $1'} | sed 's/:$//'`; do
		# RX RSS
		echo -e "IRQ ${IRQNUM}\t${DEV}:${I} RX:" `cat /proc/irq/${IRQNUM}/smp_affinity` " = cpu " `cat /proc/irq/${IRQNUM}/smp_affinity_list`
		# TX XPS
		echo -e "\t${DEV}:${I} TX:" `cat /sys/class/net/${DEV}/queues/tx-${I}/xps_cpus`
		I=$((I+1))
	done
done

# set async irq
IRQNUM=`grep mlx4-async /proc/interrupts | awk {'print $1'} | sed 's/:$//'`
echo -e "IRQ ${IRQNUM}\tmlx4async:" `cat /proc/irq/${IRQNUM}/smp_affinity` " = cpu " `cat /proc/irq/${IRQNUM}/smp_affinity_list`
