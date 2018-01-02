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

sudo apt-get --assume-yes autoremove

numUpdates=$(sudo apt-get --assume-no upgrade | grep -E "^\ \ " | wc -w)
numUpdates2=$(sudo apt-get --assume-no dist-upgrade | grep -E "^\ \ " | wc -w)

let numtotal=numUpdates+numUpdates2

if [ $numtotal -eq 0 ]
then
	notify-send --urgency=low --expire-time=60000 "No hay ninguna actualización disponible"
elif [ $numtotal -lt 4 ] && [ $numtotal -gt 0 ]
then
	notify-send --urgency=low --expire-time=60000 "Se han detectado $numtotal actualizaciones"
elif [ $numtotal -lt 10 ] && [ $numtotal -gt 3 ]
then
	notify-send --urgency=normal --expire-time=60000 "Se han detectado $numtotal actualizaciones"
elif [ $numtotal -lt 18 ] && [ $numtotal -gt 9 ]
then
	notify-send --urgency=critical --expire-time=60000 "Se han detectado $numtotal actualizaciones"
fi
