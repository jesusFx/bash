#! /bin/bash

sudo apt-get update

numUpdates=$(sudo apt-get --assume-no upgrade | grep -E "^\ \ " | wc -w)

if [ $numUpdates -eq 0 ]
then
	notify-send --urgency=low --expire-time=15000 "No hay ninguna actualización disponible"
fi

if [ $numUpdates -lt 4 ] && [ $numUpdates -gt 0 ]
then
	notify-send --urgency=low --expire-time=15000 "Se han detectado $numUpdates actualizaciones"
fi

if [ $numUpdates -lt 10 ] && [ $numUpdates -gt 3 ]
then
	notify-send --urgency=normal --expire-time=15000 "Se han detectado $numUpdates actualizaciones"
fi

if [ $numUpdates -lt 18 ] && [ $numUpdates -gt 9 ]
then
	notify-send --urgency=critical --expire-time=15000 "Se han detectado $numUpdates actualizaciones"
fi