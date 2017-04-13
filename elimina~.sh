#! /bin/bash

#Este script de bash se encarga de borrar los ficheros basura terminados en ~ o en .gch de la carpeta o subcarpetas especificadas

if [ $# == 0 ]
then
	echo "Se esperaba $0 <ruta de fichero> (¡Cuidado de usar la ruta / con sudo!)"
else
	OLDIFS=$IFS
	IFS=$'\n'
	for x in $(sudo find $1 | grep -E '~$')
	do
		rm $x
		echo "Fichero $x eliminado"
	done

	for x in $(sudo find $1 | grep -E '.gch$')
	do
		rm $x
		echo "Fichero $x eliminado"
	done
	IFS=$OLDIFS
fi
