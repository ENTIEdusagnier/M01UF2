#!/bin/bash

SERVER="10.65.0.57"
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
	echo "KO_HEADER" | nc $SERVER $PORT
	exit 1
fi
sleep 2
echo "BOOOM" | nc $SERVER $PORT


echo "(6) Listen"
DATA1=`nc -l -p $PORT -w $TIMEOUT`
#echo $DATA1

echo "(9) Test HandShake"
if [ "$DATA1" != "OK_HEADER" ];then
	#echo "KO_HEATHER"
	sleep 2
	echo "KO_HEADER" | nc $SERVER $PORT
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

echo "Succesful"
exit 0
