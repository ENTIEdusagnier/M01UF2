#!/bin/bash

PORT=3333
TIMEOUT=1

echo "Server de EFPT"
echo "(0) Listen"
DATA=`nc -l -p $PORT -w $TIMEOUT`
echo $DATA
PATRON_IP='([0-9]*\.){3}[0-9]*'
CLIENT=`echo "$DATA" | grep -Eo "$PATRON_IP"`
echo "$CLIENT" 

echo "(3) Test & Send"
if [ "$DATA" != "EFPT 1.0 $CLIENT" ];then
	echo "KO_HEATHER"
	sleep 3
	echo "KO_HEATHER" | nc "$CLIENT" $PORT
	exit 1
fi

echo "OK_HEATHER"
sleep 2
echo "OK_HEATHER" | nc "$CLIENT" $PORT


echo "(4) Listen"
DATA1=`nc -l -p $PORT -w $TIMEOUT`
echo $DATA1


echo "(7) Test & Send"
if [ "$DATA1" != "BOOOM" ];then
	echo "KO_HEATHER"
	sleep 1
    echo "KO_HEATHER" | nc "$CLIENT" $PORT
    exit 2
fi

echo "OK_HEATHER"
sleep 2
echo "OK_HEATHER" | nc "$CLIENT" $PORT


echo "(8) Listen"
FILENAME=`nc -l -p $PORT -w $TIMEOUT`
echo $FILENAME

echo "(12) Test & Store & Send"
FILE_NAME=`echo "$FILENAME" | awk '{print $2}'`
echo "$FILE_NAME"

if [ "$FILENAME" != "FILE_NAME $FILE_NAME" ];then
	echo "KO_FILE_NAME"
    sleep 2
    echo "KO_FILE_NAME" | nc "$CLIENT" $PORT
    exit 3
fi

echo "OK_FILE_NAME"
sleep 2
echo "OK_FILE_NAME" | nc "$CLIENT" $PORT

echo "(13) Listen File & Listen Hash"
FILE=`nc -l -p $PORT -w $TIMEOUT`
echo $FILE

HASH=`nc -l -p $PORT -w $TIMEOUT`
echo $HASH

echo "(16) Store & Send"
echo "$FILE" > /home/enti/M01UF2/EFPT/inbox/output_$CLIENT.txt
CREATE_HASH=`md5sum /home/enti/M01UF2/EFPT/inbox/output_$CLIENT.txt | awk '{print $1}'`

while [ "$CREATE_HASH" != "$HASH" ]
do
	echo "REQUEST_FILE" | nc $CLIENT $PORT
	FILE=`nc -l -p $PORT -w $TIMEOUT`
	echo $FILE
	echo "$FILE" > /home/enti/M01UF2/EFPT/inbox/output_$CLIENT.txt
	CREATE_HASH=`md5sum /home/enti/M01UF2/EFPT/inbox/output_$CLIENT.txt | awk '{print $1}'`
done

echo "OK_DATA" | nc $CLIENT $PORT
echo "OK_DATA FILE RECIVED PERFECTLY"
