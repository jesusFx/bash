#! /bin/bash

echo "$1 $2 $3"

if [ $2 = '0777' ] && [ $3 = 'jesus/' ]
then
   notify-send --urgency=critical "No modifiques los permisos de "$3" o el sistema se puede volver inestable. Acceso denegado"
   killall -9 bash
else
   $1 $2 $3
fi
