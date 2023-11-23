#!/bin/bash

SERVER="10.65.0.59"
PORT=3333
MYIP=`ip address | grep -Eo 'inet ([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`

echo "Cliente de EFPT"
echo "(1) Send"
echo "EFPT 1.0 $MYIP" | nc $SERVER $PORT


echo "(2) Listen"
DATA=`nc -l -p $PORT -w 0`
echo $DATA


echo "(5) Test & Send (HandShake)"
if [ "$DATA" != "OK_HEATHER" ];then
	echo "KO Heather"
	exit 1
fi
sleep 2
echo "BOOOM" | nc $SERVER $PORT


echo "(6) Listen"
DATA1=`nc -l -p $PORT -w 0`
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
FILENAME_CHECK=`nc -l -p $PORT -w 0`
echo $FILENAME_CHECK

echo ("11.5 Check")
if [ "$FILENAME_CHECK" != "OK_FILE_NAME" ]
	echo "KO_FILE_NAME"
	sleep 2
	echo "KO_FILE_NAME" | nc $SERVER $PORT
	exit 3
fi 
echo "OK_FILE_NAME"

