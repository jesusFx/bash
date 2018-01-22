#! /bin/bash

#------------------------------FUNCIONES DE LAS UTILIDADES-----------------------------#

function informacion (){
	sleep 5
	echo "Bienvenido $USER! cuyo identificador es $UID."
	echo "Esta es la shell $SHLVL, que lleva $SECONDS arrancada"
	echo "La arquitectura es $MACHTYPE y el cliente de terminal es $TERM."
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

function liberaMemoria (){
	sync
	echo 1 > /proc/sys/vm/drop_caches #Nivel de agresividad (1- suave; 3- muy agresivo)
	echo "Limpiando la caché..."
	echo "Memoria liberada."
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

function nieve(){
	LINES=$(tput lines)
	COLUMNS=$(tput cols)
	 
	declare -A snowflakes
	declare -A lastflakes
	 
	clear
	 
	function move_flake() {
	i="$1"
	 
	if [ "${snowflakes[$i]}" = "" ] || [ "${snowflakes[$i]}" = "$LINES" ]; then
	snowflakes[$i]=0
	else
	if [ "${lastflakes[$i]}" != "" ]; then
	printf "\033[%s;%sH \033[1;1H " ${lastflakes[$i]} $i
	fi
	fi
	 
	printf "\033[%s;%sH*\033[1;1H" ${snowflakes[$i]} $i
	 
	lastflakes[$i]=${snowflakes[$i]}
	snowflakes[$i]=$((${snowflakes[$i]}+1))
	}
	 
	while :
	do
	i=$(($RANDOM % $COLUMNS))
	 
	move_flake $i
	 
	for x in "${!lastflakes[@]}"
	do
	move_flake "$x"
	done
	 
	sleep 0.1
	done
}

function prioridadProcesos (){
	#Script que modifica la prioridad nice de los procesos indicados

	a=$(pidof caja)
	b=$(pidof metacity)
	c=$(pidof mate-power-manager)

	sudo renice -n -5 $a #Otorga mas prioridad al proceso caja
	sudo renice -n -5 $b #Otorga mas prioridad al proceso metacity
	sudo renice -n -15 $c #Otorga mucha mas prioridad al proceso mate-power-manager

	dia=`date +"%d/%m/%Y"`
	hora=`date +"%H:%M"`
	echo "Hora de cambio de permisos: $dia a las $hora" >> /home/jesus/horaCambiaPermisos.log

	echo ""
	echo "Se ha modificado exitosamente la prioridad de los procesos Caja, Metacity y del Gestor de Energia para que funcionen bajo el estándar impuesto por el administrador. Finalizando..."
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

function convierteJPG (){
	#Script que modifica los .JPG y .jpeg por .jpg y transforma .png a .jpg

	sudo apt-get -y install imagemagick &> /dev/null

	if [ $# != 1 ]
	then
		echo "Se esperaba un argumento carpeta objetivo"
	else
		for x in $1*.JPG
		do
			basename "$x"
			cp "$x" "$x"'.jpg' 
			rm "$x"
		done

		for x in $1*.jpeg
		do
			basename "$x"
			cp "$x" "$x"'.jpg' 
			rm "$x"
		done

		for x in $1*.png
		do
			basename "$x"
			convert "$x" "$x"'.jpg'
			rm "$x"
		done
	fi
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

function borraFicherosBasura (){
	#Este script de bash se encarga de borrar los ficheros basura terminados en ~ o en .gch de la carpeta o subcarpetas especificadas, además de limpiar el fichero /tmp
			
	echo -n "Introduzca ruta de carpeta: "
	read ruta

	if [ -d $ruta ]
	then
		OLDIFS=$IFS
		IFS=$'\n'
		for x in $(sudo find $ruta | grep -E '~$')
		do
			rm $x
			echo "Fichero $x eliminado"
		done

		for x in $(sudo find $ruta | grep -E '.gch$')
		do
			rm $x
			echo "Fichero $x eliminado"
		done
		IFS=$OLDIFS
		sudo rm -R /tmp
	else
		echo "Se esperaba una ruta valida (¡Cuidado de usar la ruta / con sudo!)"
	fi
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

function copiaSeguridad (){
	#Este script realiza una copia de seguridad de los archivos situados en la carpeta Descargas y Escritorio en el Disco local de otra particion montada

	sudo apt-get -y install gcp python-progressbar &> /dev/null 

	sleep 5

	usuario="jesus" #Usuario al cual se va a hacer la copia
	error="$HOME/error.log" #Ruta de la carpeta donde se exportara el fichero de error temporal
	log="$HOME/horaCopiaSeguridad.log" #Ruta de la carpeta donde ira el log de la hora de copia de seguridad
	carpetaFstab=$(cat /etc/fstab | grep -oE "/media/[A-Z][a-z]*_[a-z]*")
	carpetaDestino="/media/$usuario/Mis\ datos" #Ruta de la carpeta hacia donde se quiere copiar
	carpetaDestino2="/media/Mis_datos"
	particionDestino="/dev/sda1" #Particion donde se encuentra la ruta de la carpeta destino
	rutaCopia="$carpetaDestino/Copia\ de\ seguridad\ Linux" #Ruta donde ira la copia de seguridad
	rutaCopia2="$carpetaDestino2/Copia\ de\ seguridad\ Linux"

	#Comprueba que el log de error existe y si existe lo elimina
	if [ -f $error ]
	then
		sudo rm $error 2>> $error
	fi

	#Comprueba que la carpeta donde hacer la copia de seguridad no haya sido montada ya
	if [ "$carpetaDestino" == "$carpetaFstab" ]
	then #Si fue montada no se hace nada
		echo "La carpeta "$carpetaDestino" esta montada ya"
		echo "14.3% completado"
		carpetaActiva="$carpetaDestino"
		rutaActiva="$rutaCopia"
	elif [ "$carpetaDestino2" == "$carpetaFstab" ]
	then
		echo "La carpeta "$carpetaDestino2" esta montada ya"
		echo "14.3% completado"
		carpetaActiva="$carpetaDestino2"
		rutaActiva="$rutaCopia2"
	else #Si no fue montada se monta de forma local
		sudo mkdir "$carpetaDestino" 2>> $error
		sudo mount "$particionDestino" "$carpetaDestino" 2>> $error
		echo "La carpeta "$carpetaDestino" ha sido montada con exito"
		echo "14.3% completado"
		carpetaActiva="$carpetaDestino"
		rutaActiva="$rutaCopia"
	fi

	#Intenta borrar las carpetas Descargas y Escritorio copiadas localmente
	echo "Borrando carpetas "$rutaActiva"/Descargas y "$rutaActiva"/Escritorio..."
	if [ -d "$rutaActiva"/"$usuario" ]
	then
		rm -R "$rutaActiva"/"$usuario" 2>> $error
		echo "Carpeta "$rutaActiva"/"$usuario" borrada"
		echo "42.9% completado"

		#Copia el contenido de Descargas en la carpeta local
		echo "Copiando archivos a "$rutaActiva"..."
		gcp -r "$HOME" "$rutaActiva"
		echo "58.9% completado"

		if [ $? -eq 0 ]
		then
			echo "Directorio "$HOME" copiado"
		fi

		echo "71.5% completado"

		#Desmonta y borra la carpeta local
		echo "Desmontando particion..."
		sudo umount "$carpetaActiva" 2>> $error
		echo "Borrando carpeta local.."
		sudo rmdir "$carpetaActiva" 2>> $error
		echo "85.8% completado"

		sleep 2
		echo "100% completado"
		echo "Finalizando..."
	else
		echo "Fallo al ubicar la carpeta. No se pudo borrar la informacion..."
		exit
	fi

	#Elimina el fichero log de error si no ha registrado ningun error
	compruebaError=$(wc -l $error | grep "^0")
	if [ $? -eq 0 ]
	then
		sudo rm $error
	else
		echo "Se ha devuelto diversos estados de error. Pueden ser consultados en la carpeta "$HOME""
	fi

	#Guarda un log con la fecha y hora a la que se ha realizado la copia 
	dia=`date +"%d/%m/%Y"`
	hora=`date +"%H:%M"`
	echo "Hora de copia de seguridad: $dia a las $hora" >> $log
	echo "Se ha generado un log. Puede consultarse en la carpeta "$HOME""
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

function actualizaSistema (){
	#Script para actualizar el sistema

	echo ""
	echo "Buscando actualizaciones de los repositorios..."
	echo "****************************************************"
	sudo apt-get update
	echo "****************************************************"
	echo ""
	echo ""
	echo ""
	echo "Buscando actualizaciones de librerias..."
	echo "****************************************************"
	sudo apt-get upgrade
	echo "****************************************************"
	echo ""
	echo ""
	echo ""
	echo "Buscando actualizaciones de librerias inteligentes..."
	echo "****************************************************"
	sudo apt-get dist-upgrade
	echo "****************************************************"
	echo ""
	echo ""
	echo ""
	echo "Eliminando dependencias innecesarias..."
	echo "****************************************************"
	sudo apt-get autoremove
	echo "****************************************************"
	echo ""
	echo ""
	echo ""
	echo "Limpiando paquetes descargados localmente de instalaciones antiguas..."
	echo "****************************************************"
	sudo apt-get autoclean
	echo ""
	echo ""
	echo ""
	echo "Corrigiendo dependencias rotas de instalaciones fallidas..."
	echo "****************************************************"
	sudo apt-get -f install
	echo ""
	echo ""
	echo ""
	echo "Actualizando cache de paquetes y comprobando dependencias rotas..."
	echo "****************************************************"
	sudo apt-get check
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

function log (){
	echo -e "\nVersión 0.1 (14/7/17):"
	echo -e "\tSe han introducido 3 script de bash"
	echo -e "\tSe ha introducido una salida y una opción por defecto"
	echo -e "\tSe ha introducido un menú de elección"
	echo -e "\tSe ha introducido una opción de log con los cambios del script"
	echo -e "\tSe ha incluido un warning inicial"
	echo -e "\tSe ha introducido un control de bucle del menú"
	echo "Versión 0.2 (15/7/17):"
	echo -e "\tSe han introducido 5 nuevos script de bash"
	echo -e "\tSe ha modificado el script 6"
	echo "Versión 0.3 (11/8/17):"
	echo -e "\tSe ha modificado el script 7"
	echo "Versión 0.4 (05/1/18):"
	echo -e "\tSe ha modificado el script 7"
	echo "Versión 0.5 (12/1/18):"
	echo -e "\tSe ha incluido un menú de ayuda"
	echo -e "\tSe ha dividido el script en una ejecución de funciones por defecto sin sudo y con sudo por argumento"
	echo -e "\tLas opciones han sido divididas en funciones modulares"
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

function ayuda (){
	echo "La estructura es ./utilidades.sh help para devolver esta opcion o ./utilidades.sh [sudo] para usar las opciones por defecto del script o con sudo para ejecutarlas con sudo"
	echo -en "\nPulsa cualquier letra para continuar: "
	read letter
}

#--------------------------PROGRAMA PRINCIPAL----------------------------------------#
#------------------------------------------------------------------------------------#
#--------------------------PROGRAMA PRINCIPAL----------------------------------------#
#------------------------------------------------------------------------------------#
#--------------------------PROGRAMA PRINCIPAL----------------------------------------#
#------------------------------------------------------------------------------------#
#--------------------------PROGRAMA PRINCIPAL----------------------------------------#

number="default"

if [ "$1" == "help" ]
then
	ayuda
elif [ "$1" != "sudo" ]
then
	
	while [ $number != "exit" ];
	do

		echo "Puedes consultar la ayuda con la opción help o el argumento help"
		echo ""
		echo -e "\t***************************************************************\n"
		echo -e "\t\t\t<<<<MENU>>>>\n"
		echo -e "\t\t1 - Información del sistema"
		echo -e "\t\t2 - Caen copos de nieve en el terminal"
		echo -e "\t\texit - Finalizar script"
		echo -e "\t\tlog - Cambios en el programa"
		echo -e "\t\thelp - Ayuda"
		echo -e "\n\t****************************************************************"

		echo ""

		echo -n "Haga su eleccion: "
		read number
		echo ""

		case $number in
			1 )
				informacion;;
			2 )
				nieve;;
			exit )
				echo "Saliendo..."
				sleep 1
				reset;;
			log )
				log;;
			help )
				ayuda;;
			* )
				echo "Opcion no contemplada"
				echo -en "\nPulsa cualquier letra para continuar: "
				read letter;;
		esac
		clear

	done

else

	condemor="4cc3530f11ba11dc98077dd9a99a8a9390bc19b5c4a6a4c86a85b496af4b5d748207fd3bf67ceccdf823f94c33e975c54808f29d270a9ec6748c8d704c311e43  -"

	while [ "$pass2" != "$condemor" ];
	do

		echo -en "\nIntroduce la contraseña: "
		read -s pass

		pass2=`echo $pass | sha512sum`

		if [ "$pass2" == "$condemor" ]
		then
			clear
			echo "$pass" | sudo -S ls > /dev/null
			clear
		else
			echo -e "\nContraseña incorrecta. Vuelve a intentarlo...\n"
		fi

	done

	echo "SUDO activado"

	while [ "$number" != "exit" ];
	do

		echo "Puedes consultar la ayuda con la opción help o el argumento help"
		echo -e "\t***************************************************************\n"
		echo -e "\t\t\t<<<<MENU>>>>\n"
		echo -e "\t\t1 - Información del sistema"
		echo -e "\t\t2 - Limpieza de cache de sistema (no usar mucho)"
		echo -e "\t\t3 - Caen copos de nieve en el terminal"
		echo -e "\t\t4 - Cambio de prioridades nice de procesos"
		echo -e "\t\t5 - Convierte de .JPG, .jpeg o .png a .jpg"
		echo -e "\t\t6 - Elimina ficheros terminados en ~ o .gch"
		echo -e "\t\t7 - Realiza copia de seguridad de ficheros críticos del sistema"
		echo -e "\t\t8 - Actualiza el sistema"
		echo -e "\t\texit - Finalizar script"
		echo -e "\t\tlog - Cambios en el programa"
		echo -e "\t\thelp - Ayuda"
		echo -e "\n\t****************************************************************"

		echo ""

		echo -n "Haga su eleccion: "
		read number
		echo ""

		case $number in
			1 )
				informacion;;
			2 )
				liberaMemoria;;
			3 )
				nieve;;
			4 )
				prioridadProcesos;;
			5 )
				convierteJPG;;
			6 )
				borraFicherosBasura;;
			7 )
				copiaSeguridad;;
			8 )
				actualizaSistema;;
			exit )
				echo "Saliendo..."
				sleep 1
				reset;;
			log )
				log;;
			help )
				ayuda;;
			* )
				echo "Opcion no contemplada"
				echo -en "\nPulsa cualquier letra para continuar: "
				read letter;;
		esac
		clear

	done

fi