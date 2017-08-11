#! /bin/bash

#Detecta cuantos dispositivos de tipo mouse hay conectados. Si es 1 solo esta el touchpad y lo activa y permite la pulsacion de raton por touchpad, si hay mas de 1 entonces lo desactiva

seccioncritica=default
idsynaptics=`xinput list | grep SynPS/2 | grep -oE "[=]([0-9]){1,2}[^\)]" | grep -oE "([0-9]){1,2}"`

while :
do
	mousecount=`grep mouse /proc/bus/input/devices |grep Handler |wc -l`
	if [ "$mousecount" -eq "1" ]
	then
		xinput --enable $idsynaptics
		gsettings set 'org.mate.peripherals-touchpad' tap-to-click true
		if [ $seccioncritica != 'touch1' ]
		then	
			notify-send --urgency=low --expire-time=2000 "Synaptics Touchpad activado"
			seccioncritica=touch1
		fi
	elif [ "$mousecount" -gt "1" ]
	then
		xinput --disable $idsynaptics
		if [ $seccioncritica != 'touch2' ]
		then
			notify-send --urgency=normal --expire-time=2000 "Synaptics Touchpad desactivado"
			seccioncritica=touch2
		fi
	fi
	sleep 0.20
done
