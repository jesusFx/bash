#!/bin/bash

#Requiere activar la arquitectura i386 si tienes el sistema de 64 bits
#sudo dpkg --add-architecture i386
#Luego instala steam de la forma habitual del repositorio o instala el paquete .deb
#sudo apt-get install steam steam-launcher

#Pon este script como lanzador en lugar del lanzador de escritorio por defecto de Steam

export LD_PRELOAD='/usr/$LIB/libstdc++.so.6' #Exporta a todos los procesos hajos que son afectados tambien
export DISPLAY=:0
#export LIBGL_DEBUG=verbose
steam
