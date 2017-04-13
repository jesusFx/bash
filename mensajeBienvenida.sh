#! /bin/bash

user="i42jiroj"
pass="i42jiroj"
comodin="atajo"
nombre="Jesus"
error=no
cadena=0
cadena2=0

function ctrl_c() {
	killall -15 mate-notification-daemon
        notify-send --urgency=critical --expire-time=3000 "No intentes sortear la seguridad tramposo..."
}

function ctrl_d() {
        cadena=default
        cadena2=default
        error=yes
        killall -15 mate-notification-daemon
        notify-send --urgency=critical --expire-time=3000 "Has ido demasiado lejos. Expulsandote de la terminal..."
        sleep 2
        #Si falta el script limpiaProcesos.sh no se podrá finalizar este script y habrá que hacerlo a mano 
        env DISPLAY=:0 mate-terminal -e "/bin/bash --init-file ~/limpiaProcesos.sh"
        sleep 1
        killall -9 bash
}

function ctrl_z() {
	killall -15 mate-notification-daemon
        notify-send --urgency=critical --expire-time=3000 "Deja de intentarlo. Admite que esto te viene grande..."
}

# Captura Ctrl-C, Ctrl-D? y Ctrl-Z para evitar que sorteen la seguridad
trap ctrl_c INT
trap ctrl_d SIGHUP SIGTERM ERR
trap ctrl_z SIGTSTP

until [ $cadena = $user ] && [ $cadena2 = $pass ] || [ $cadena = $comodin ]; do
  notify-send --urgency=normal --expire-time=3000 "Hola desconocido, introduce el nombre de usuario: "
  read -s cadena
  if [ $cadena = $user ]
  then
    killall -15 mate-notification-daemon 
    notify-send --urgency=normal --expire-time=3000 "Introduce contraseña: "
    read -s cadena2
    if [ $cadena2 = $pass ]
    then
      killall -15 mate-notification-daemon 
      notify-send --urgency=low --expire-time=3000 "Bienvenido $nombre. Ahora ya puedes trabajar con el terminal."
      sleep 1
    elif [ $error = 'no' ]
    then
      killall -15 mate-notification-daemon 
      notify-send --urgency=critical --expire-time=3000 "Contraseña incorrecta."
    fi
  elif [ $cadena = $comodin ]
  then
    killall -15 mate-notification-daemon 
    notify-send --urgency=low --expire-time=3000 "Acceso privilegiado permitido. Ya puedes trabajar."
  else
    if [ $error = 'no' ]
    then
      killall -15 mate-notification-daemon 
      notify-send --urgency=critical --expire-time=3000 "Usuario incorrecto." 
      sleep 1
      killall -15 mate-notification-daemon
    fi
  fi
done
