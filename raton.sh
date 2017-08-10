#! /bin/bash

#Script para detección automática de ratón y deshabilitado del touchpad Synaptics

#Requiere la previa modificación del fichero xorg.conf para activar el elemento del touchpad que recibe las señales externas

while :
do
	mousecount=`grep mouse /proc/bus/input/devices |grep Handler |wc -l`
	if [ "$mousecount" -eq "1" ]
	then
		synclient TouchpadOff=0
	elif [ "$mousecount" -gt "1" ]
	then
		synclient TouchpadOff=1
	fi
	sleep 0.25
done
