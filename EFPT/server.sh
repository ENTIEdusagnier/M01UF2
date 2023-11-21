#!/bin/bash

CLIENT="localhost"
PORT=3333

echo "Server de EFPT"
echo "(0) Listen"
DATA=`nc -l -p $PORT -w 0`
echo $DATA
PATRON_IP="([0-9]{1,3}\.){3}[0-9]{1,3}"


echo "(3) Test & Send"
if ! echo "$DATA" | grep -Eq "EFPT 1.0 $patron_ip";then
	echo "Entrada incorrecta"
	sleep 1
	echo "KO Heather" | nc $CLIENT $PORT
	exit 1
fi

echo "Entrada correcta"
sleep 2
echo "OK Heather" | nc $CLIENT $PORT


echo "(4) Listen"
DATA1=`nc -l -p $PORT -w 0`
echo $DATA1


echo "(7) Test & Send"
if [ "$DATA1" != "BOOOM" ];then
	echo "Entrada incorrecta"
	sleep 1
    echo "KO Heather" | nc $CLIENT $PORT
    exit 2
fi

echo "Entrada correcta"
sleep 2
echo "OK Heather" | nc $CLIENT $PORT


echo "(8) Listen"
DATA2=`nc -l -p $PORT -w 0`
echo $DATA2
