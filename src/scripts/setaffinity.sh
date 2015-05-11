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

# array of targeted CPUs
declare -a CPU=("10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "30" "31" "32" "33" "34" "35" "36" "37" "38" "39")
CPULEN="${#CPU[@]}"

# unused CPU for all other irqs
UNUSED="0"

# set default for newly registered irqs
echo "1" > /proc/irq/default_smp_affinity
# set everything
for IRQNUM in `ls /proc/irq/ | grep -v default_smp_affinity`; do
	echo "$UNUSED" > /proc/irq/${IRQNUM}/smp_affinity_list 2> /dev/null
done


# set RX-TX irqs
for DEV in "$ENP" "$ENPD1"; do
	# set everything
	echo "0" | tee /sys/class/net/${DEV}/queues/tx-*/xps_cpus > /dev/null
	I=0
	for IRQNUM in `grep -w "$DEV" /proc/interrupts | awk {'print $1'} | sed 's/:$//'`; do
		# RX RSS
		echo "${CPU[$I]}" > /proc/irq/${IRQNUM}/smp_affinity_list
		echo -e "IRQ ${IRQNUM}\t${DEV}:${I} RX:" `cat /proc/irq/${IRQNUM}/smp_affinity`
		# TX XPS
		MASK=`cat /proc/irq/${IRQNUM}/smp_affinity`
		echo "$MASK" > /sys/class/net/${DEV}/queues/tx-${I}/xps_cpus
		echo -e "\t${DEV}:${I} TX:" `cat /sys/class/net/${DEV}/queues/tx-${I}/xps_cpus`
		I=$((I+1))
	done
done

# set async irq
LASTCPU=$((CPULEN-1))
IRQNUM=`grep mlx4-async /proc/interrupts | awk {'print $1'} | sed 's/:$//'`
echo "${CPU[$LASTCPU]}" > /proc/irq/${IRQNUM}/smp_affinity_list
echo -e "IRQ ${IRQNUM}\tmlx4async:" `cat /proc/irq/${IRQNUM}/smp_affinity`
