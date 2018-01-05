#! /bin/bash

sleep 2

error=-1

conexion_ok (){
	while [ $error -ne 0 ]; do
		ping google.es -c 2 2> /dev/null
		error=$?
		if [ $error -ne 0 ]
		then
			sudo killall -15 mate-notification-daemon 2> /dev/null
			notify-send --urgency=critical --expire-time=60000 "No hay conexión a Internet. Reintentando..."
			sleep 10
		fi
	done
	sudo killall -15 mate-notification-daemon 2> /dev/null
}

sleep 1 && wmctrl -r "Actualizacion" -b add,above &

(

echo "# Buscando actualizaciones."

conexion_ok

notify-send --urgency=low --expire-time=60000 "Buscando actualizaciones..."

estadoConex=-1

while [ $estadoConex -lt 0 ];
do
	sudo apt-get update
	if [ $? -eq 0 ]
	then
		estadoConex=1
	fi
done

echo "25"
echo "# Removiendo librerías sobrantes."

sudo apt-get --assume-yes autoremove

echo "50"
echo "# Contando actualizaciones upgrade."

numUpdates=$(sudo apt-get --assume-no upgrade | grep -E "^\ \ " | wc -w)

echo "75"
echo "# Contando actualizaciones dist-upgrade."

numUpdates2=$(sudo apt-get --assume-no dist-upgrade | grep -E "^\ \ " | wc -w)

estado=-1

sudo killall -15 mate-notification-daemon 2> /dev/null

if [ $numUpdates -eq 0 ] && [ $numUpdates2 -eq 0 ];
then
	echo "90"
	echo "# Mostrando actualizaciones."
	notify-send --urgency=low --expire-time=60000 "No hay ninguna actualización disponible"
	estado=1
fi

if [ $numUpdates -gt 0 ] && [ $numUpdates2 -eq 0 ] && [ $estado -lt 1 ];
then
	echo "90"
	echo "# Mostrando actualizaciones."
	notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates actualizaciones upgrade"
	estado=1
fi

if [ $numUpdates -eq 0 ] && [ $numUpdates2 -gt 0 ] && [ $estado -lt 1 ];
then
	echo "90"
	echo "# Mostrando actualizaciones."
	notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates2 actualizaciones dist-upgrade/paquetes a eliminar"
	estado=1
fi

if [ $numUpdates -gt 0 ] && [ $numUpdates2 -gt 0 ] && [ $estado -lt 1 ];
then
	if [ $numUpdates -lt 5 ] && [ $numUpdates -gt 0 ] && [ $estado -lt 1 ];
	then
		echo "90"
		echo "# Mostrando actualizaciones."
		notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates actualizaciones upgrade"
		notify-send --urgency=low --expire-time=60000 "Se han detectado $numUpdates2 actualizaciones dist-upgrade/paquetes a eliminar"
		estado=1
	elif [ $numUpdates -lt 12 ] && [ $numUpdates -gt 4 ] && [ $estado -lt 1 ];
	then
		echo "90"
		echo "# Mostrando actualizaciones." ; sleep 4
		notify-send --urgency=normal --expire-time=60000 "Se han detectado $numUpdates actualizaciones upgrade"
		notify-send --urgency=normal --expire-time=60000 "Se han detectado $numUpdates2 actualizaciones dist-upgrade/paquetes a eliminar"
		estado=1
	elif [ $numUpdates -lt 60 ] && [ $numUpdates -gt 11 ] && [ $estado -lt 1 ];
	then
		echo "90"
		echo "# Mostrando actualizaciones."
		notify-send --urgency=critical --expire-time=60000 "Se han detectado $numUpdates actualizaciones upgrade"
		notify-send --urgency=critical --expire-time=60000 "Se han detectado $numUpdates2 actualizaciones dist-upgrade/paquetes a eliminar"
		estado=1
	fi
fi

echo "# " ; sleep 2
echo "99"

echo "# Proceso finalizado." ; sleep 4
echo "100"

) |
zenity --progress --title="Progress Status" --text="First Task." --percentage=0 --auto-close --auto-kill 2> /dev/null

(( $? != 0 )) && zenity --error --text="Error in zenity command."
