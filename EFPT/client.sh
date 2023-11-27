#!/bin/bash

SERVER="localhost"
PORT=3333
MYIP=`ip address | grep -Eo 'inet ([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
TIMEOUT=1

echo "Cliente de EFPT"
echo "(1) Send"
echo "EFPT 1.0 $MYIP" | nc $SERVER $PORT


echo "(2) Listen"
DATA=`nc -l -p $PORT -w $TIMEOUT`

echo "(5) Test & Send"
if [ "$DATA" != "OK_HEATHER" ];then
	echo "KO_HEATHER"
	exit 1
fi
sleep 2
echo "BOOOM" | nc $SERVER $PORT


echo "(6) Listen"
DATA1=`nc -l -p $PORT -w $TIMEOUT`
echo $DATA1

echo "(9) Test HandShake"
if [ "$DATA1" != "OK_HEATHER" ];then
	echo "KO_HEATHER"
	sleep 2
	echo "KO_HEATHER" | nc $SERVER $PORT
	exit 2
fi

echo "OK_HEATHER (Handshake)"

sleep 2
echo "(10) Send file"
echo "FILE_NAME fary1.txt" | nc $SERVER $PORT

echo "(11) Listen"
FILENAME_CHECK=`nc -l -p $PORT -w $TIMEOUT`
echo $FILENAME_CHECK

echo "(11.5) Check"
if [ "$FILENAME_CHECK" != "OK_FILE_NAME" ];then
	echo "KO_FILE_NAME"
	sleep 2
	echo "KO_FILE_NAME" | nc $SERVER $PORT
	exit 3
fi 

echo "(14) Send file & Hash"
CONV_FILE=`img2txt /home/enti/M01UF2/EFPT/img/fary1.jpg > /home/enti/M01UF2/EFPT/img/img.txt`
SEND_FILE=`cat /home/enti/M01UF2/EFPT/img/img.txt | nc $SERVER $PORT`
echo "File Sent"

CREATE_HASH=`md5sum /home/enti/M01UF2/EFPT/img/img.txt | awk '{print $1}'`
echo $CREATE_HASH
sleep 2
SEND_HASH=`echo "$CREATE_HASH" | nc "$SERVER" "$PORT"`

echo "(15) Listen"
FILE_OK=`nc -l -p $PORT -w $TIMEOUT`
echo "$FILE_OK"

if [ "$FILE_OK" == "REQUEST_FILE" ];then
	while [ "$FILE_OK" != "OK_DATA" ]
	do
		SEND_FILE=`cat /home/enti/M01UF2/EFPT/img/img.txt | nc $SERVER $PORT`
		FILE_OK=`nc -l -p $PORT -w $TIMEOUT`
		echo "$FILE_OK"
	done
elif [ "$FILE_OK" == "OK_DATA" ];then
	exit 0
else
	echo "KO_DATA"
fi
