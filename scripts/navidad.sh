#!/bin/bash

RUTA=`pwd`

if [ $# -eq 0 ];then #Nos permite saber si ha introducido texto
	echo "No se ha puesto ningun nombre de archivo" 
	exit 1
elif [ $# -ge 1 ];then
	NOMBRE=$1
fi

NOMBRE_SIMPLE=`echo "$NOMBRE" | cut -d. -f1` # Nos permite sacar el nombre de la extension

if [ ! -f "$NOMBRE_SIMPLE.txt" ];then
	echo "Archivo introducido no existe o no tiene extension .txt"
	exit 2
fi

echo $NOMBRE_SIMPLE

if [ -f "$NOMBRE_SIMPLE.mp3" ]; then
    echo "El archivo mp4 ya existe"
	ffplay -autoexit $NOMBRE_SIMPLE.mp3	
	
else
	echo "El archivo mp4 no existe"
	
	text2wave $NOMBRE -o $NOMBRE_SIMPLE.wav
	ffmpeg -i $NOMBRE_SIMPLE.wav $NOMBRE_SIMPLE.mp3
	rm $NOMBRE_SIMPLE.wav
	ffplay -autoexit $NOMBRE_SIMPLE.mp3
fi
