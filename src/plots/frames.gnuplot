# plotting
set title "Frame rate throughput"
set terminal png
set output "frames.png"
set grid y
set xrange [0:1550]
set xtics ("64" 40, 128, 265, 512, 768, 1024, 1280, 1518)
#set ytics (1e6, 10e6, 60e6)
set ytics ("3 Mpps" 3e6, "6 Mpps" 6e6, "10 Mpps" 10e6, "14.88 Mpps" 14.88e6, "20 Mpps" 20e6, "30 Mpps" 30e6, "40 Mpps" 40e6, "50 Mpps" 50e6, "60 Mpps" 60e6)
set yrange [0:60e6]
set ylabel "Frame rate [fps]"
set xlabel "Frame size [B]"
set key box
set xzeroaxis linetype -1           # xzeroaxis same as border
plot [0:1518] (40*10**9)/((x+20)*8) title "40 GbE", "frames.data" title "Linux" with linespoints
