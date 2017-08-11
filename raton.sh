#Detecta cuantos dispositivos de tipo mouse hay conectados. Si es 1 solo esta el touchpad y lo activa y permite la pulsacion de raton por touchpad, si hay mas de 1 entonces lo desactiva

while :
do
	mousecount=`grep mouse /proc/bus/input/devices |grep Handler |wc -l`
	if [ "$mousecount" -eq "1" ]
	then
		synclient TouchpadOff=0
		gsettings set org.mate.peripherals-touchpad tap-to-click true
	elif [ "$mousecount" -gt "1" ]
	then
		synclient TouchpadOff=1
	fi
	sleep 0.25
done
