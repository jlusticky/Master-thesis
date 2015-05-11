MAC="f4:52:14:5e:6c:70"
MACD1="f4:52:14:5e:6c:71"

ENP=`ip a s | grep -B 1 "$MAC" | head -n 1 | cut -f 2 -d' ' | sed 's/:$//'`
ENPD1=`ip a s | grep -B 1 "$MACD1" | head -n 1 | cut -f 2 -d' ' | sed 's/:$//'`
