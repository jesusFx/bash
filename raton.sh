#! /bin/bash

#author:			jesusFx
#date:				22/01/2018
#notes:				Actualmente descontinuado. Última vez probado en el sistema Linux Mint v.18.2 "Sonya" MATE 64 bits
#description:		Detecta cuantos dispositivos de tipo mouse hay conectados. Si es 1 solo está el touchpad y lo activa 
#					y permite la pulsación de ratón por touchpad, si hay más de 1 entonces lo desactiva

estado=999

comando=`ps -e | grep "checkUpdates.sh"`
if [ $comando != '' ]
then
	while [ $estado -gt 0 ];
	do
		ps -e | grep "checkUpdates.sh"
		estado=$?
	done
fi

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
			killall -9 mate-notification-daemon 2> /dev/null
			notify-send --urgency=low --expire-time=2000 "Notificación del controlador Synaptics TouchPad" "Synaptics Touchpad activado" -i /home/jesus/Imágenes/etouchpad.png
			seccioncritica=touch1
		fi
	elif [ "$mousecount" -gt "1" ]
	then
		xinput --disable $idsynaptics
		if [ $seccioncritica != 'touch2' ]
		then
			killall -9 mate-notification-daemon 2> /dev/null
			notify-send --urgency=normal --expire-time=8000 "Notificación del controlador Synaptics TouchPad" "Se ha inhabilitado el TouchPad porque el controlador libre del Touchpad de Synaptics ha detectado otro dispositivo puntero conectado al ordenador" -i /home/jesus/Imágenes/dtouchpad.png
			seccioncritica=touch2
		fi
	fi
	sleep 0.20
done
