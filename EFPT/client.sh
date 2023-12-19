#!/bin/bash

if [ $# -eq 0 ];then #Nos permite saber cuantos parametros hay 
	SERVER="localhost"

elif [ $# -ge 1 ];then 
	SERVER=$1
fi

PORT=3333
MYIP=`ip address | grep -Eo 'inet ([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
TIMEOUT=1

echo "Cliente de EFPT"
if [ $# -eq 2 ];then
	echo "(-1)"
	echo "RESET" | $SERVER $PORT
	sleep 2
fi

echo "(1) Send"
echo "EFTP 1.0 $MYIP" | nc $SERVER $PORT


echo "(2) Listen"
DATA=`nc -l -p $PORT -w $TIMEOUT`

echo "(5) Test & Send"
if [ "$DATA" != "OK_HEADER" ];then
	exit 1
fi
sleep 2
echo "BOOOM" | nc $SERVER $PORT


echo "(6) Listen"
DATA1=`nc -l -p $PORT -w $TIMEOUT`
#echo $DATA1

echo "(9) Test HandShake"
if [ "$DATA1" != "OK_HANDSHAKE" ];then
	echo "KO_HANDSHAKE"
	exit 2
fi


sleep 2
echo "(9a) Send & Check NUM files"

CONTADOR=0
for file in `ls /home/enti/M01UF2/EFPT/send`;do
	((CONTADOR++))
done
SENDNUM=`echo "NUM_FILES $CONTADOR" | nc "$SERVER" "$PORT"`

echo "(9b) Listen & Check"

NUMOK=`nc -l -p "$PORT" -w "$TIMEOUT"`
if [ $NUMOK != "OK_FILE_NUM" ];then
	echo "KO_NUM_FILES"
	exit 3
fi
#echo "OK_NUM"


echo "(10a) Send Files"
sleep 1 
for files in `ls /home/enti/M01UF2/EFPT/send`;do
	HASHNAME=`echo "$files" | md5sum | awk '{print $1}'`
	#echo "$files $HASHNAME"
	sleep 2
	echo "FILE_NAME $files $HASHNAME" | nc "$SERVER" "$PORT"

	echo "(11a) Listen"
	FILEOK=`nc -l -p $PORT -w $TIMEOUT`

	echo "(14) Test & Send"
	if [ $FILEOK != "OK_FILE_NAME" ];then
		echo "KO_FILE"
		exit 4
	fi
	#echo "FILE_"$files"_ OK"
	sleep 2
	
	SEND=`cat /home/enti/M01UF2/EFPT/send/$files | nc $SERVER $PORT`
	
	echo "(15) Listen"
	FILESEND=`nc -l -p $PORT -w $TIMEOUT`


	echo "(18) Test & Send"

	if [ "$FILESEND" != "OK_DATA" ];then
		echo "File: $files not send correctly!"
	else
		echo "SEND OK $files"
		HASHFILE=`md5sum /home/enti/M01UF2/EFPT/send/$files | awk '{print $1}'`
		
		sleep 2
		echo "FILE_MD5 $HASHFILE" | nc $SERVER $PORT
		
		echo "(19) Listen"
		MD5LISTEN=`nc -l -p $PORT -w $TIMEOUT`

		echo "(21) Test"
		if [ "$MD5LISTEN" != "OK_FILE_MD5"  ];then
			echo "KO_FILE_MD5 $files"
		fi
		#echo "OK_MD5 $files"
	fi
done
echo "FIN"
exit 0
