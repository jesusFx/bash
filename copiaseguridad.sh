#! /bin/bash

#Este script realiza una copia de seguridad de los archivos situados en la carpeta Descargas y Escritorio en el Disco local de otra particion montada

usuario=jesus #Usuario al cual se va a hacer la copia
error=$HOME/error.log #Ruta de la carpeta donde se exportara el fichero de error temporal
log=$HOME/horaCopiaSeguridad.log #Ruta de la carpeta donde ira el log de la hora de copia de seguridad
carpetaDestino=/media/$usuario/Mis\ datos #Ruta de la carpeta hacia donde se quiere copiar
particionDestino=/dev/sda1 #Particion donde se encuentra la ruta de la carpeta destino
rutaCopia=$carpetaDestino/Copia\ de\ seguridad\ Linux #Ruta donde ira la copia de seguridad

#Comprueba que el log de error existe y si existe lo elimina
if [ -f $error ]
then
	sudo rm $error 2>> $error
fi

#Comprueba que la carpeta donde hacer la copia de seguridad no haya sido montada ya
if [ -d "$carpetaDestino" ]
then #Si fue montada no se hace nada
	echo "La carpeta "$carpetaDestino" esta montada ya"
	echo "14.3% completado"
else #Si no fue montada se monta de forma local
	sudo mkdir "$carpetaDestino" 2>> $error
	sudo mount "$particionDestino" "$carpetaDestino" 2>> $error
	echo "La carpeta "$carpetaDestino" ha sido montada con exito"
	echo "14.3% completado"
fi

#Intenta borrar las carpetas Descargas y Escritorio copiadas localmente
echo "Borrando carpetas "$rutaCopia"/Descargas y "$rutaCopia"/Escritorio..."
if [ -d "$rutaCopia"/Descargas ]
then
    rm -R "$rutaCopia"/Descargas 2>> $error
fi

if [ -d "$rutaCopia"/Escritorio ]
then
    rm -R "$rutaCopia"/Escritorio 2>> $error
fi
echo "42.9% completado"

#Copia el contenido de Descargas en la carpeta local
echo "Copiando archivos a "$rutaCopia"..."
cp -R "$HOME"/Descargas "$rutaCopia" 2>> $error

if [ $? -eq 0 ]
then
    echo "Directorio "$HOME"/Descargas copiado"
fi

echo "57.2% completado"
    
#Copia el contenido de Escritorio en la carpeta local
echo "Copiando archivos a "$rutaCopia"..."
cp -R "$HOME"/Escritorio "$rutaCopia" 2>> $error

if [ $? -eq 0 ]
then
    echo "Directorio "$HOME"/Escritorio copiado"
fi

echo "71.5% completado"

#Desmonta y borra la carpeta local
echo "Desmontando particion..."
sudo umount "$carpetaDestino" 2>> $error
echo "Borrando carpeta local.."
sudo rmdir "$carpetaDestino" 2>> $error

echo "85.8% completado"

echo "100% completado"
echo "Finalizando..."

#Elimina el fichero log de error si no ha registrado ningun error
compruebaError=$(wc -l $error | grep "^0")
if [ $? -eq 0 ]
then
    sudo rm $error
fi

#Guarda un log con la fecha y hora a la que se ha realizado la copia 
dia=`date +"%d/%m/%Y"`
hora=`date +"%H:%M"`
echo "Hora de copia de seguridad: $dia a las $hora" >> $log
