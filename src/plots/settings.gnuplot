# plotting
set title "Impact of system settings"
set terminal png
set output "settings.png"
set style fill solid
set boxwidth 0.5
set yrange [1e6:7e6]
set format y "%8.0f"
set grid y
set ylabel "Frame rate [fps]"
plot "settings.data" using 1:3:xtic(2) with boxes lc rgb "#AA0000" notitle
