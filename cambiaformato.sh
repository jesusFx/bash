#! /bin/bash

#Script que modifica los .JPG y .jpeg por .jpg y transforma .png a .jpg

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
		convert "$x" "$x"'.jpg' 2> formatError.log
		if [ $? != 0 ]
		then
		  echo "No se ha encontrado el comando necesario para transformar png a jpg. Se procede a su instalación..."
		  sudo apt-get install imagemagick
		  convert "$x" "$x"'.jpg'
		fi 
		rm "$x"
	done
	rm formatError.log
fi
