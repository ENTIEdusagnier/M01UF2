#!/bin/bash

RUTA=`pwd`
FONDO_ROJO="\e[41m"
LETRA_BLANCA="\e[97m"
NC="\e[0m"

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

#echo $NOMBRE_SIMPLE #DEBUG

if [ -f "$NOMBRE_SIMPLE.mp3" ]; then
#    echo "El archivo mp3 ya existe" #DEBUG
	ffplay -autoexit $NOMBRE_SIMPLE.mp3	> /dev/null 2>&1 & #Para segundo plano
	
    cp "$NOMBRE" "$NOMBRE_SIMPLE"_TEMP.txt
    sed -i '/^[[:space:]]*$/d' "$NOMBRE_SIMPLE"_TEMP.txt #Saco las lineas sin espacios del archivo copiado
#   cat "$NOMBRE"_TEMP #DEBUG
	
	LINEAS=`wc -l "$NOMBRE_SIMPLE"_TEMP.txt | awk '{print $1}'`
	for i in $(seq $LINEAS);do

        LINE=`cat "$NOMBRE_SIMPLE"_TEMP.txt | head -n 1` #Variable que saca la primeria linea
        echo -e ""$FONDO_ROJO $LETRAS_BLANCAS"$LINE""$NC" | cowsay -f snowman
        sed -i '1d' "$NOMBRE_SIMPLE"_TEMP.txt #Borra la primera linea
        sleep 2
        clear

    done

    rm "$NOMBRE_SIMPLE"_TEMP.txt

else
	echo "El archivo mp3 no existe"
	
	text2wave $NOMBRE -o $NOMBRE_SIMPLE.wav
	ffmpeg -i $NOMBRE_SIMPLE.wav $NOMBRE_SIMPLE.mp3 > /dev/null 2>&1 #Para que no salga nada por terminal
	

	cp "$NOMBRE" "$NOMBRE_SIMPLE"_TEMP.txt
	sed -i '/^[[:space:]]*$/d' "$NOMBRE_SIMPLE"_TEMP.txt
#	cat "$NOMBRE"_TEMP #DEBUG

	LINEAS=`wc -l "$NOMBRE_SIMPLE"_TEMP.txt | awk '{print $1}'`
	rm $NOMBRE_SIMPLE.wav

	ffplay -autoexit $NOMBRE_SIMPLE.mp3  > /dev/null 2>&1 & #Para segundo plano
	
	for i in $(seq $LINEAS);do

		LINE=`cat "$NOMBRE_SIMPLE"_TEMP.txt | head -n 1`
		echo -e ""$FONDO_ROJO $LETRAS_BLANCAS"$LINE""$NC" | cowsay -f snowman
		sed -i '1d' "$NOMBRE_SIMPLE"_TEMP.txt
		sleep 1
		clear
	
	done
#	rm $NOMBRE_SIMPLE.mp3 #DEBUG
	rm "$NOMBRE_SIMPLE"_TEMP.txt
fi
