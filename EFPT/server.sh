#!/bin/bash

PORT=3333

echo "Server de EFPT"
echo "(0) Listen"
DATA=`nc -l -p $PORT -w 0`
echo $DATA
PATRON_IP='([0-9]*\.){3}[0-9]*'
CLIENT=`echo "$DATA" | grep -Eo "$PATRON_IP"`
echo "$CLIENT" 

echo "(3) Test & Send"
if [ "$DATA" != "EFPT 1.0 "$CLIENT"" ];then
	echo "KO_HEATHER"
	sleep 1
	echo "KO_HEATHER" | nc "$CLIENT" $PORT
	exit 1
fi

echo "OK_HEATHER"
sleep 2
echo "OK_HEATHER" | nc "$CLIENT" $PORT


echo "(4) Listen"
DATA1=`nc -l -p $PORT -w 0`
echo $DATA1


echo "(7) Test & Send"
if [ "$DATA1" != "BOOOM" ];then
	echo "KO_HEATHER"
	sleep 1
    echo "KO_HEATHER" | nc "$CLIENT" $PORT
    exit 2
fi

echo "KO_HEATHER"
sleep 2
echo "OK_HEATHER" | nc "$CLIENT" $PORT


echo "(8) Listen"
FILENAME=`nc -l -p $PORT -w 0`
echo $FILENAME

echo "(12) Test & Store & Send"
FILE_NAME=`echo "$FILENAME" | awk '{print $2}'`
echo "$nombre_archivo"

if [ "$FILENAME" != "FILE_NAME $FILE_NAME" ]
	echo "Entrada incorrecta"
    sleep 1
    echo "KO_FILE_NAME" | nc "$CLIENT" $PORT
    exit 3
fi

echo "Entrada correcta"
sleep 2
echo "OK_FILE_NAME" | nc "$CLIENT" $PORT



