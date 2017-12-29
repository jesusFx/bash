#! /bin/bash

sleep 5

error=-1

while [ $error -ne 0 ]; do
	ping google.es -c 3
	error=$?
	if [ $error -ne 0 ]
	then
		notify-send --urgency=critical --expire-time=60000 "No hay conexión a Internet. Reintentando..."
		sleep 30
	fi
done

sudo apt-get update

numUpdates=$(sudo apt-get --assume-no upgrade | grep -E "^\ \ " | wc -w)

if [ $numUpdates -eq 0 ]
then
	notify-send --urgency=low --expire-time=60000 "No hay ninguna actualización disponible"
elif [ $numUpdates -lt 4 ] && [ $numUpdates -gt 0 ]
then
	notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates actualizaciones"
elif [ $numUpdates -lt 10 ] && [ $numUpdates -gt 3 ]
then
	notify-send --urgency=normal --expire-time=60000 "Se han detectado $numUpdates actualizaciones"
elif [ $numUpdates -lt 18 ] && [ $numUpdates -gt 9 ]
then
	notify-send --urgency=critical --expire-time=60000 "Se han detectado $numUpdates actualizaciones"
fi