#! /bin/bash

horaactual=`date +'%H:%M'`

reset
echo -n "Mensaje de alarma: "
read mensajealarma

echo -n "Hora a la que suena la alarma (HH:MM): "
read hora

echo "Alarma programada para las "$hora""

while [ "$hora" != "$horaactual" ]
do
	horaactual=`date +'%H:%M'`
	if [ "$hora" == "$horaactual" ]
	then
		notify-send -u normal -t 60000 "Notificación de alarma" "$mensajealarma" -i /home/jesus/Imágenes/alarma.jpg
	fi
done
echo "Finalizando alarma..."
sleep 2
reset
