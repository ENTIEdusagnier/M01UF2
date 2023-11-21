#!/bin/bash

SERVER="10.65.0.59"
PORT=3333
MYIP=`ip address | grep -Eo 'inet ([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`

echo "Cliente de EFPT, $MYIP"
echo "(1) Send"
echo "EFPT 1.0" | nc $SERVER $PORT


echo "(2) Listen"
DATA=`nc -l -p $PORT -w 0`
echo $DATA


echo "(5) Test & Send (HandShake)"
if [ "$DATA" != "OK Heather" ];then
	echo "KO Heather"
	exit 1
fi
sleep 2
echo "BOOOM" | nc $SERVER $PORT


echo "(6) Listen"
DATA1=`nc -l -p $PORT -w 0`
echo $DATA1

echo "(9) Test HandShake"
if [ "$DATA1" != "OK Heather" ];then
	echo "KO Heather"
	exit 2
fi

echo "Funciona"
