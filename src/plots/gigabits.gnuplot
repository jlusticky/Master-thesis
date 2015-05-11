# plotting
set title "Gbps throughput"
set terminal png
set output "gigabits.png"
set grid y
set xrange [0:1550]
set xtics ("64" 50, 128, 265, 512, 768, 1024, 1280, 1518)
#set ytics ("3 Mpps" 3e6, "6 Mpps" 6e6, "10 Mpps" 10e6, "14.88 Mpps" 14.88e6, "20 Mpps" 20e6, "30 Mpps" 30e6, "40 Mpps" 40e6, "50 Mpps" 50e6, "60 Mpps" 60e6)
#set yrange [0:45]
set ylabel "Throughput [Gbps]"
set xlabel "Frame size [B]"
#set key box
set xzeroaxis linetype -1           # xzeroaxis same as border
plot "gigabits.data" notitle with linespoints
