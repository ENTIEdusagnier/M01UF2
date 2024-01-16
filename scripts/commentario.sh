#!/bin/bash

echo "Gestor de comentarios"
read -p "Introduzaca (1) Para leer comentarios (2) Para insertar comentario " USUARIO


if [ $USUARIO == 1 ];then

	echo "SELECT * FROM fary_adventure.comments" | mysql -ucomentador -N 


elif [ $USUARIO == 2 ];then
	read -p "INTRODUZCA TU COMENTARIO: " COMENTARIO
	PALABROTA="jolines"

	CONTADOR_PALABROTA=`echo "$COMENTARIO" | grep -i -c $PALABROTA`
	
	if [ $CONTADOR_PALABROTA == 0 ];then

		echo "INSERT INTO fary_adventure.comments (comment) VALUES ('$COMENTARIO');" | mysql -ucomentador
	else
		echo "No se dicen palabrotas"
	fi
else
	exit 1
fi

