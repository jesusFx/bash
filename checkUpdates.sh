#! /bin/bash

sleep 9

error=-1

while [ $error -ne 0 ]; do

	ping google.es -c 4 2> /dev/null

	error=$?

	echo $error
	if [ $error -gt 0 ] && [ $error -lt 3 ]
	then
		killall -15 mate-notification-daemon 2> /dev/null
		notify-send --urgency=critical --expire-time=60000 "No hay conexión a Internet o es muy inestable. Reintentando..."
		sleep 3
	elif [ $error -eq 0 ]
	then
		error=0
	fi

done
killall -15 mate-notification-daemon 2> /dev/null

notify-send --urgency=low --expire-time=60000 "Buscando actualizaciones..."

apt-get update

apt-get --assume-yes autoremove

numUpdates=$(apt-get --assume-no upgrade | grep -E "^\ \ " | wc -w)
numUpdates2=$(apt-get --assume-no dist-upgrade | grep -E "^\ \ " | wc -w)

estado=-1

killall -15 mate-notification-daemon 2> /dev/null

if [ $numUpdates -eq 0 ] && [ $numUpdates2 -eq 0 ];
then
	notify-send --urgency=low --expire-time=60000 "No hay ninguna actualización disponible"
	estado=1
fi

if [ $numUpdates -gt 0 ] && [ $numUpdates2 -eq 0 ] && [ $estado -lt 1 ];
then
	notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates actualizaciones upgrade"
	estado=1
fi

if [ $numUpdates -eq 0 ] && [ $numUpdates2 -gt 0 ] && [ $estado -lt 1 ];
then
	notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates2 actualizaciones dist-upgrade/paquetes a eliminar"
	estado=1
fi

if [ $numUpdates -gt 0 ] && [ $numUpdates2 -gt 0 ] && [ $estado -lt 1 ];
then
	if [ $numUpdates -lt 5 ] && [ $numUpdates -gt 0 ] && [ $estado -lt 1 ];
	then
		notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates actualizaciones upgrade"
		notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates2 actualizaciones dist-upgrade/paquetes a eliminar"
		estado=1
	elif [ $numUpdates -lt 12 ] && [ $numUpdates -gt 4 ] && [ $estado -lt 1 ];
	then
		notify-send --urgency=normal --expire-time=60000 "Se han detectado $numUpdates actualizaciones upgrade"
		notify-send --urgency=normal --expire-time=60000 "Se han detectado $numUpdates2 actualizaciones dist-upgrade/paquetes a eliminar"
		estado=1
	elif [ $numUpdates -lt 60 ] && [ $numUpdates -gt 11 ] && [ $estado -lt 1 ];
	then
		notify-send --urgency=critical --expire-time=60000 "Se han detectado $numUpdates actualizaciones upgrade"
		notify-send --urgency=critical --expire-time=60000 "Se han detectado $numUpdates2 actualizaciones dist-upgrade/paquetes a eliminar"
		estado=1
	fi
fi