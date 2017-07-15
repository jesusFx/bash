#! /bin/bash

number="default"

echo "WARNING: RECOMENDABLE USAR SUDO PARA INICIAR EL SCRIPT"
sleep 1
echo -e "A las opciones 2 les afecta directamente sudo\n"

while [ $number != "exit" ]
do

echo -e "\t***************************************************************\n"
echo -e "\t\t\t<<<<MENU>>>>\n"
echo -e "\t\t1 - Información del sistema"
echo -e "\t\t2 - Limpieza de cache de sistema (no usar mucho)"
echo -e "\t\t3 - Caen copos de nieve en el terminal"
echo -e "\t\texit - Finalizar script"
echo -e "\t\tlog - Cambios en el programa"
echo -e "\n\t****************************************************************"

echo ""

echo -n "Haga su eleccion: "
read number
echo ""

case $number in
	1 )
		sleep 5
		echo "Bienvenido $USER! cuyo identificador es $UID."
		echo "Esta es la shell $SHLVL, que lleva $SECONDS arrancada"
		echo "La arquitectura es $MACHTYPE y el cliente de terminal es $TERM."
		echo -en "\nPulsa cualquier letra para continuar: "
		read letter
		;;
	2 )
		sync
		echo 1 > /proc/sys/vm/drop_caches #Nivel de agresividad (1- suave; 3- muy agresivo)
		echo "Limpiando la caché..."
		echo "Memoria liberada."
		echo -en "\nPulsa cualquier letra para continuar: "
		read letter
		;;
	3 )
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
		;;
	exit )
		echo "Saliendo..."
		sleep 1
		reset
		;;
	log )
		echo "Versión 0.1:"
		echo -e "\tSe han introducido 3 script de bash"
		echo -e "\tSe ha introducido una salida y una opción por defecto"
		echo -e "\tSe ha introducido un menú de elección"
		echo -e "\tSe ha introducido un log con los cambios del script"
		echo -e "\tSe ha incluido un warning inicial"
		echo -e "\tSe ha introducido un control de bucle del menú"
		echo -en "\nPulsa cualquier letra para continuar: "
		read letter
		;;
	* )
		echo "Opcion no contemplada"
		echo -en "\nPulsa cualquier letra para continuar: "
		read letter
		;;
esac
clear
done
