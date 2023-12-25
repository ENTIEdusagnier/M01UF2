#!/bin/bash

RUTA=`pwd`

if [ $# -eq 0 ];then #Nos permite saber si ha introducido texto
	echo "No se ha puesto ningun nombre de archivo" 

elif [ $# -ge 1 ];then
	NOMBRE=$1
fi

NOMBRE=`echo $NOMBRE | awk '{print $1}'`

echo $NOMBRE

if [ -f "$RUTA/$NOMBRE.mp4" ]; then
    echo "El archivo mp4 ya existe"
	
	
	
else
	echo "El archivo mp4 no existe"
	
	
fi
