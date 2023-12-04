#!/bin/bash

if [ $# == 0 ];then #Nos permite saber cuantos parametros hay 
	SERVER="localhost"

elif [ $# == 1 ];then 
	SERVER=$1
fi

PORT=3333
MYIP=`ip address | grep -Eo 'inet ([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
TIMEOUT=1

echo "Cliente de EFPT"
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
echo "(10) Send file"
FILENAME="fary2.txt"
HASH_FILENAME=`echo "$FILENAME" | md5sum | awk '{print $1}'`
echo "FILE_NAME $FILENAME $HASH_FILENAME" | nc $SERVER $PORT

echo "(11) Listen"
FILENAME_CHECK=`nc -l -p $PORT -w $TIMEOUT`
#echo $FILENAME_CHECK

echo "(11.5) Check"
if [ "$FILENAME_CHECK" != "OK_FILE_NAME" ];then
	echo "KO_FILE_NAME" | nc $SERVER $PORT
	exit 3
fi

echo "(14) Send file"
CONV_FILE=`img2txt /home/enti/M01UF2/EFPT/img/fary2.jpg > /home/enti/M01UF2/EFPT/img/img2.txt`
SEND_FILE=`cat /home/enti/M01UF2/EFPT/img/img2.txt | nc $SERVER $PORT`
#echo "File Sent"

echo "(15) Listen"
FILE_OK=`nc -l -p $PORT -w $TIMEOUT`
#echo "$FILE_OK"

if [ "$FILE_OK" != "OK_DATA" ]; then
	echo "KO DATA" | nc $SERVER $PORT
	exit 4
fi

echo "(18) Send Hash"
CREATE_HASH=`md5sum /home/enti/M01UF2/EFPT/img/img2.txt | awk '{print $1}'`
#echo $CREATE_HASH
sleep 2
SEND_HASH=`echo "FILE_MD5 $CREATE_HASH" | nc "$SERVER" "$PORT"`


echo "(19) Listen"
FILE_OK=`nc -l -p $PORT -w $TIMEOUT`
#echo "$FILE_OK"


echo "(21) Test"
if [ "$FILE_OK" != "OK_FILE_MD5" ];then
	#To resend file until is OK
	#while [ "$FILE_OK" != "OK_DATA" ]
	#do
		#sleep 1
		#SEND_FILE=`cat /home/enti/M01UF2/EFPT/img/img.txt | nc $SERVER $PORT`
		#sleep 2
		#SEND_HASH=`echo "$CREATE_HASH" | nc "$SERVER" "$PORT"`
		#FILE_OK=`nc -l -p $PORT -w $TIMEOUT`
		#echo "$FILE_OK"
	#done
#elif [ "$FILE_OK" == "OK_DATA" ];then
	#exit 0
	exit 5
fi


echo "Send amount of files"

CONTADOR=0
for file in `ls /home/enti/M01UF2/EFPT/send`;do
	((CONTADOR++))
done
SENDNUM=`echo $CONTADOR | nc "$SERVER" "$PORT"`

echo "Listen & Check"
NUMOK=`nc -l -p "$PORT" -w "$TIMEOUT"`
if [ $NUMOK != "OK_NUM" ];then
	echo "KO_NUM"
	exit 6
fi
echo "OK_NUM"


echo "SEND FILES"
sleep 5 
for files in `ls /home/enti/M01UF2/EFPT/send`;do
	HASHNAME=`echo "$files" | md5sum | awk '{print $1}'`
	echo "$files $HASHNAME"
	sleep 2
	echo "$files $HASHNAME" | nc "$SERVER" "$PORT"
	FILEOK=`nc -l -p $PORT -w $TIMEOUT`
	if [ $FILEOK != "OK_FILE" ];then
		echo "KO_FILE"
		exit 6
	fi
	echo "FILE_OK"
done
exit 0
