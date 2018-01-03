#! /bin/bash

#Ejecuta el entorno terminal y dentro de él inicia el script copiaseguridad.sh

sleep 3
env DISPLAY=:0 mate-terminal -e "/bin/bash --init-file limpiaProcesos.sh"
