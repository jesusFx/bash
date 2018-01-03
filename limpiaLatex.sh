#! /bin/bash

OLDIFS=$IFS
IFS=$'\n'
 for x in $(sudo find /home/jesus/Escritorio | grep -E '\.aux$')
 do
	rm $x
	echo "Fichero $x eliminado"
 done

 for x in $(sudo find /home/jesus/Escritorio | grep -E '\.log$')
 do
	rm $x
	echo "Fichero $x eliminado"
 done
 
 for x in $(sudo find /home/jesus/Escritorio | grep -E '\.synctex.gz$')
 do
	rm $x
	echo "Fichero $x eliminado"
 done
IFS=$OLDIFS
